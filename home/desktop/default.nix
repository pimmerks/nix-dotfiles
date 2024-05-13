{ lib, self, config, pkgs, ... }: {

  imports = [
    ./mako.nix
    ./waybar
    ./wallpapers
  ];

  nixpkgs.config.allowUnfree = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd.enable = true;

    settings = import ./hyprland-config.nix { inherit config self pkgs lib; };
  };

  services = {
    wlsunset = {
      enable = true;
      latitude = "51.5";
      longitude = "5.4";
      temperature.night = 3500;
    };

    cliphist = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };
  };
}
