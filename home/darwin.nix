{ config, pkgs, ... }:

{
  # macOS-specific home-manager configuration
  imports = [
    ./common.nix
  ];

  # macOS-specific environment variables
  home.sessionVariables = {
    # ESP-IDF (macOS only)
    IDF_PATH = "$HOME/Projects/esp-idf";
  };

  home.sessionPath = [
    "$HOME/.opencode/bin"
  ];

  # macOS-specific aliases
  programs.zsh.shellAliases = {
    setfont = "~/dotfiles/.config/ghostty/set_ghostty_font_size.sh";
    purpledoc = "java -jar ~/project/purpledoc/purpledoc.jar";

    # ESP-IDF (macOS)
    get_idf = "source $IDF_PATH/export.sh";
    setup_clangd = "setup-esp32-clangd.sh";
  };
}
