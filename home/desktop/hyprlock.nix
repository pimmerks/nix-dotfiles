{ lib, self, config, pkgs, ... }:
let
  monitors = {
    left = "HDMI-A-2";
    right = "HDMI-A-1";
  };

  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;
  timeUntilSuspend = 30 * 60;

  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  playerctl = "${pkgs.playerctl}/bin/playerctl";

  lockscreen-album-art = "${self.packages.${pkgs.system}.lockscreen-album-art}/bin/lockscreen-album-art";

  placeholder = ./Spotify_Icon_RGB_White.png;
in rec
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = timeUntilScreenOff - timeUntilLock;
        ignore_empty_input = true;
        no_fade_out = true; # bit buggy, so disable it
        no_fade_in = true;

      };

      background = [
        {
          monitor = monitors.left;
          path = "/tmp/lockscreen-left.png";
          blur_passes = 3;
          blur_size = 8;
          color = "rgb(0,0,0)";
        }
        {
          monitor = monitors.right;
          path = "/tmp/lockscreen-right.png";
          blur_passes = 3;
          blur_size = 8;
          color = "rgb(0,0,0)";
        }
      ];

      image = [
        {
          monitor = "";

          # The path here is a symlink to the result of lockscreen-album-art.
          # That means that command need to be run before starting hyprlock...
          path = "${placeholder}";
          size = 709;
          rounding = 2;

          border_size = 0;
          border_color = "rgba(0, 0, 0, 0)";

          reload_time = 1; # reload every second
          reload_cmd = "${lockscreen-album-art}";

          position = "16, 16";
          halign = "left";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:100] date +%T";
          color = "rgb(255, 255, 255)";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          shadow_passes = 3;
          shadow_size = 4;

          position = "0, 16";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = ''cmd[update:1000] ${playerctl} metadata --format "Now playing: {{ artist }} - {{ title }}"'';
          color = "rgb(255, 255, 255)";

          font_size = 14;
#          font_family = "JetBrainsMono Nerd Font";
          shadow_passes = 3;
          shadow_size = 4;

          position = "120, 50";
          halign = "left";
          valign = "bottom";
        }
      ];

      input-field = [
        {
          size = "250, 40";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };
}
