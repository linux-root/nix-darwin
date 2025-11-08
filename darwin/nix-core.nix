{ lib, ... }:

{
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
    
    # NOTE: auto-optimise-store is deprecated and can corrupt store
    
    # Prevent garbage collection of currently active derivations
    keep-going = true;
    
    # NOTE: allow-unfree should be configured via nixpkgs.config, not nix.settings
    
    # Improve build performance
    max-jobs = "auto";
    cores = 0; # Use all available cores
    
    # Enable sandbox for better security
    sandbox = true;
    
    # Use substituters for faster builds
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  
  # Configure garbage collection
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; }; # Weekly on Sunday at 2 AM
    options = "--delete-older-than 30d";
  };
  
  # Configure store optimization (replaces deprecated auto-optimise-store)
  nix.optimise = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; }; # Weekly on Sunday at 3 AM
  };
  
  # NOTE: services.nix-daemon.enable is no longer needed as nix-darwin manages it automatically
}
