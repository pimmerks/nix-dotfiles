{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
    };
  };
}
