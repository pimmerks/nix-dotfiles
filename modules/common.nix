{ config, pkgs, user, ... }:
{
  nixpkgs.config.allowUnfree = true;

  users.users.${user}.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    zsh
    home-manager
  ];

  programs.zsh = {
    enable = true;
  };

}
