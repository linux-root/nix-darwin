{ pkgs, localUsername, ... }:
{
  users.users.${localUsername} = {
    home = "/Users/${localUsername}";
    shell = pkgs.zsh;
  };
}

