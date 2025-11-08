{ config, pkgs, ... }:

{
  # Linux-specific home-manager configuration
  # Works on both NixOS and standalone (Ubuntu, etc.)
  imports = [
    ./common.nix
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # Add Linux-specific vars here if needed
  };

  # Linux-specific aliases
  programs.zsh.shellAliases = {
    # Add Linux-specific aliases here if needed
  };
}
