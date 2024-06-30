{ config, self, pkgs, lib, ... }:
let
  wallpapers = [
    ./nixos-wallpaper-catppuccin-mocha.png
    ./rolling-fog-left.jpg
    ./rolling-fog-right.jpg
  ];

  mkWallpaperDir = file: "${file}";

  preloads = builtins.map (w: mkWallpaperDir w) wallpapers;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = preloads;

      wallpaper = [
        "HDMI-A-2, ${mkWallpaperDir (builtins.elemAt wallpapers 1)}"
        "HDMI-A-1, ${mkWallpaperDir (builtins.elemAt wallpapers 2)}"
      ];
    };
  };
}
