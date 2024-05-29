{ ... }:
let
  default-dir = "Desktop/wallpapers";
  wallpapers = [
    "nixos-wallpaper-catppuccin-mocha.png"
    "rolling-fog-left.jpg"
    "rolling-fog-right.jpg"
  ];

  mkWallpaperDir = file: "~/${default-dir}/${file}";

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
        # manual for now... :(
        "HDMI-A-2, ${mkWallpaperDir (builtins.elemAt wallpapers 1)}"
        "HDMI-A-1, ${mkWallpaperDir (builtins.elemAt wallpapers 2)}"
      ];
    };
  };

  home.file = builtins.listToAttrs (
    builtins.map
      (
        w: { name = "${default-dir}/${w}"; value = { source = ./${w}; }; }
      )
      wallpapers
  );
}
