{ config, pkgs, ... }:

{
  # This is shared configuration that works on all platforms:
  # - macOS (via nix-darwin + home-manager)
  # - NixOS (via nixos + home-manager)
  # - Ubuntu/other Linux (via standalone home-manager)

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Packages available on all platforms
  home.packages = with pkgs; [
    git
    neovim
    lazygit
    zellij
    eza
    file
    jq
    zoxide
    imagemagick
    poppler
    yazi
    btop
  ];

  # Environment variables (cross-platform)
  home.sessionVariables = {
    EDITOR = "nvim";
    GPG_TTY = "$(tty)";
    EXA_COLORS = "uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.zsh = {
    enable = true;

    # Enable zsh plugins via home-manager (better than oh-my-zsh plugins)
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Powerlevel10k - installed via Nix for all platforms
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable = true;
      theme = "";  # Empty theme since we're using Powerlevel10k
      plugins = [
        "scala"
        "docker"
      ];
    };

    # History configuration
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = false;
    };

    historySubstringSearch.enable = true;
    defaultKeymap = "emacs";

    initContent = pkgs.lib.mkMerge [
      (pkgs.lib.mkBefore ''
        # Enable caching for compinit
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path ~/.zsh/cache

        DISABLE_AUTO_UPDATE=true

        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
      # Useful zsh options
      setopt AUTO_CD           # cd by typing directory name
      setopt CORRECT          # spell correction
      setopt NO_CASE_GLOB     # case insensitive globbing

      # Initialize secrets
      [[ -f ~/.secrets/mill-sonatype.sh ]] && source ~/.secrets/mill-sonatype.sh
      [[ -f ~/.secrets/api-keys.sh ]] && source ~/.secrets/api-keys.sh

      # Custom functions
      function copy_last_command() {
         local last_cmd=$(fc -ln -1)
         echo -n "$last_cmd" | pbcopy
         echo -e "\e[32m Copied: $last_cmd\e[0m"
      }

      function tree() {
          local depth="''${1:-2}"
          if ! [[ "$depth" =~ ^[0-9]+$ ]]; then
              echo "Error: depth must be a number" >&2
              return 1
          fi
          eza --tree --level="$depth" --long --icons --git --color=always | less -R
      }

      # Yazi wrapper
      function f() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      zle -N copy_last_command
      bindkey '^Xy' copy_last_command

      # Dedicated config for Ubuntu
      if [ -f .config/zsh-os-specific-config/ubuntu.sh ]; then
        source .config/zsh-os-specific-config/ubuntu.sh
      fi

      # Dedicated config for MacOS
      if [ -f .config/zsh-os-specific-config/macos.sh ]; then
        source .config/zsh-os-specific-config/macos.sh
      fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    ''
    ];

    shellAliases = {
      # Development tools
      sc = "scala-cli";
      vimconf = "nvim ~/.config/nvim";
      ghconf = "cd ~/.config/ghostty && vim config";
      zconf = "cd ~ && nvim .zshrc";
      reload = "source ~/.zshrc";
      vim = "nvim";
      v = "nvim .";
      python = "python3";
      pip = "pip3";
      zgit = "lazygit";
      tmx = "tmux";

      # File listing (eza)
      ls = "eza --icons --color=always";
      ll = "eza -snew -alh --icons";
      xl = "eza -la --icons --color=always";

      # Terminal multiplexers
      z = "zellij";
      za = "zellij attach";

      # Other tools
      ff = "fastfetch";
      note = "nvim ~/Worklog/Notes";
      scala3 = "sbt new linux-root/scala3.g8";
    };
  };

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide integration (smart cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    # userName = "Your Name";  # Uncomment and set your name
    # userEmail = "your.email@example.com";  # Uncomment and set your email
  };

  # Neovim configuration
  # Symlink the entire nvim config directory
  xdg.configFile."nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
  };
}
