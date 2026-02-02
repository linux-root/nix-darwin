{
  description = "Multi-platform Nix configuration for macOS, NixOS, and Ubuntu";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    # Platform-specific usernames
    macosUsername = "kurro";
    linuxUsername = "w47s0n";

    # macOS-specific variables
    remoteBuilderHost = "kcberry4";
    remoteBuilderSshUser = "w47s0n";
    remoteBuilderSshKey = "/Users/kurro/.ssh/id_nix";
    builderUserAtHost = "${remoteBuilderSshUser}@${remoteBuilderHost}";
    remoteBuilderString = "${builderUserAtHost} aarch64-linux ${remoteBuilderSshKey} 1 1";

  in {
    # macOS configuration using nix-darwin
    # Build and activate with:
    # $ sudo darwin-rebuild switch --flake .#watson-computer
    darwinConfigurations."watson-computer" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        localUsername = macosUsername;
        inherit remoteBuilderString;
        enableRemoteBuilder = false;
      };
      modules = [
        # Base configuration
        ({ pkgs, ... }: {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;
        })

        # macOS system configuration modules
        ./darwin/users.nix
        ./darwin/apps.nix
        ./darwin/system.nix
        ./darwin/nix-core.nix

        # home-manager for macOS
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${macosUsername} = { pkgs, ... }: {
            imports = [ ./home/darwin.nix ];
            home.username = macosUsername;
            home.homeDirectory = "/Users/${macosUsername}";
          };
        }
      ] ++ nixpkgs.lib.optional (builtins.pathExists ./darwin/remote-builder.nix) ./darwin/remote-builder.nix;
    };

    # NixOS configuration (example - uncomment and configure when needed)
    # Build and activate with:
    # $ sudo nixos-rebuild switch --flake .#nixos-laptop
    # nixosConfigurations."nixos-laptop" = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";  # or "aarch64-linux"
    #   modules = [
    #     ./nixos/configuration.nix
    #
    #     # home-manager for NixOS
    #     home-manager.nixosModules.home-manager
    #     {
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.users.${linuxUsername} = import ./home/linux.nix;
    #     }
    #   ];
    # };

    # Standalone home-manager configuration for Ubuntu/other Linux distros
    # Activate with:
    # $ home-manager switch --flake .#w47s0n@ubuntu
    homeConfigurations."w47s0n@ubuntu" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home/linux.nix
        {
          home.username = linuxUsername;
          home.homeDirectory = "/home/${linuxUsername}";
        }
      ];
    };

    # Raspberry Pi 5 configuration (aarch64-linux)
    homeConfigurations."w47s0n@pi5" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [
        ./home/linux.nix
        {
          home.username = linuxUsername;
          home.homeDirectory = "/home/${linuxUsername}";
        }
      ];
    };
  };
}
