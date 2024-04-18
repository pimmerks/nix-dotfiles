{ lib, self, config, pkgs, ... }: {

  imports = [
    ./mako.nix
    ./waybar
  ];

  nixpkgs.config.allowUnfree = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    settings = import ./hyprland-config.nix { inherit config self pkgs lib; };
  };
}
