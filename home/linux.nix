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

  # Linux-specific zsh config
  programs.zsh.initContent = ''
    # Powerlevel10k theme (for Linux, might need different path)
    # Adjust the path based on where p10k is installed on your Linux systems
    # Common paths:
    # - /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    # - ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    if [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
      source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    elif [[ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
      source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    fi
  '';
}
