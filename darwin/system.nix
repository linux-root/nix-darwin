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
      # Apply per-user trackpad gesture settings
      sudo -u ${localUsername} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
      sudo -u ${localUsername} defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2
      sudo -u ${localUsername} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

      # Refresh UI components that read defaults
      killall Dock || true
      killall Finder || true
      killall SystemUIServer || true
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
        Clicking = false;
        TrackpadThreeFingerDrag = false;               # disable drag to free three-finger swipe
        TrackpadRightClick = true;
      };
      
      # NSGlobalDomain preferences
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleEnableSwipeNavigateWithScrolls = true;    # two-finger swipe to navigate
        "com.apple.swipescrolldirection" = true;      # natural scrolling
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
