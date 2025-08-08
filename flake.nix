{
  description = "watson-computer nix-darwin system flake";

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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
    };
    remoteBuilderHost = "kcberry4";
    remoteBuilderSshUser = "w47s0n";
    remoteBuilderSshKey = "/Users/kurro/.ssh/id_nix";
    localUsername = "kurro";

    builderUserAtHost = "${remoteBuilderSshUser}@${remoteBuilderHost}";
    remoteBuilderString = "${builderUserAtHost} aarch64-linux ${remoteBuilderSshKey} 1 1";

  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#watson-computer
    darwinConfigurations."watson-computer" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit localUsername remoteBuilderString;
        # Public repo default: keep remote builder disabled. Copy modules/remote-builder.example.nix
        # to modules/remote-builder.nix and set enableRemoteBuilder = true locally if needed.
        enableRemoteBuilder = false;
      };
      modules = [
        configuration
        ./modules/users.nix
        ./modules/apps.nix
        ./modules/system.nix
        ./modules/nix-core.nix
      ] ++ nixpkgs.lib.optional (builtins.pathExists ./modules/remote-builder.nix) ./modules/remote-builder.nix;
    };
  };
}
