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

  # Activation script to remind user about setting zsh as default shell
  home.activation.checkZshShell = config.lib.dag.entryAfter ["writeBoundary"] ''
    ZSH_PATH="${pkgs.zsh}/bin/zsh"

    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
      echo ""
      echo "⚠️  Zsh is not in /etc/shells yet!"
      echo "To set zsh as your default shell, run:"
      echo ""
      echo "  sudo sh -c 'echo $ZSH_PATH >> /etc/shells'"
      echo "  chsh -s $ZSH_PATH"
      echo ""
      echo "Then logout and login again."
      echo ""
    fi
  '';
}
