{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.terminal-notifier
  ];

  programs.kitty = {
    enable = true;
    theme = "Ayu";

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
