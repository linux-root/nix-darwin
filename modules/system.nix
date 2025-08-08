{ pkgs, localUsername, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{

  system = {
    stateVersion = 6;
    primaryUser = localUsername;

    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postActivation.text = ''
      # Refresh UI components that read defaults
      killall Dock || true
      killall Finder || true
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;  # show 24 hour clock
      
      # Dock preferences
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "right";
        tilesize = 48;
      };
      
      # Finder preferences
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        FXDefaultSearchScope = "SCcf"; # Current folder
      };
      
      # Trackpad preferences
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      
      # NSGlobalDomain preferences
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      
      # Security preferences
      screencapture.location = "~/Desktop";
      screensaver.askForPasswordDelay = 10;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

  # Basic system settings
  networking.hostName = "watson-computer";
  time.timeZone = "America/Los_Angeles";

}
