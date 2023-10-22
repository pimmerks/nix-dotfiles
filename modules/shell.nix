{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-completions
  ];

  programs.zsh = {
    enable = true;
    histSize = 10000;
    shellAliases = {};

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "refined";
    };
  };
}
