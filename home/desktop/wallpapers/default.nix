{ config, self, pkgs, lib, ... }:
let
  default-dir = "Desktop/wallpapers";
  wallpapers = [
    "nixos-wallpaper-catppuccin-mocha.png"
    "rolling-fog-left.jpg"
    "rolling-fog-right.jpg"
  ];

  mkWallpaperDir = file: "~/${default-dir}/${file}";

  preloads = builtins.map (w: "preload = ${mkWallpaperDir w}\n") wallpapers;
in
{
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
      ${lib.concatStrings preloads}

      # manual for now... :(
      wallpaper = HDMI-A-2, ${mkWallpaperDir (builtins.elemAt wallpapers 1)}
      wallpaper = HDMI-A-1, ${mkWallpaperDir (builtins.elemAt wallpapers 2)}

      splash = false
      '';
    };
  } // builtins.listToAttrs(
    builtins.map(
      w: { name = "${default-dir}/${w}"; value = { source = ./${w};}; }
    ) wallpapers
  );
}
