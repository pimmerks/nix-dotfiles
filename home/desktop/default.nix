{
  lib,
  self,
  config,
  pkgs,
  ...
}: let
  monitors = {
    left = "HDMI-A-2";
    right = "HDMI-A-1";
  };

  # 5 minutes until lock,
  # 5:30 minutes until screen off
  # 30 minutes until sleep
  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;
  timeUntilSuspend = 30 * 60;

  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in {
  imports = [
    ./mako.nix
    ./waybar
    ./wallpapers
    ./apps.nix
  ];

  nixpkgs.config.allowUnfree = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd.enable = true;

    settings = import ./hyprland-config.nix {inherit config self pkgs lib;};
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        grace = 2;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = monitors.left;
          path = "${./wallpapers/rolling-fog-left.jpg}";
          blur_passes = 1;
          blur_size = 8;
          color = "rgb(0,0,0)";
        }
        {
          monitor = monitors.right;
          path = "${./wallpapers/rolling-fog-right.jpg}";
          blur_passes = 1;
          blur_size = 8;
          color = "rgb(0,0,0)";
        }
      ];

      label = [
        {
          # Show time
          monitor = "";
          text = "$TIME";
          color = "rgb(255, 255, 255)";
          position = "0, 0";
          font_size = 20;
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }

        {
          # Show date
          monitor = "";
          text = "cmd[update:60000] date \"+%A - %F\"";
          color = "rgb(255, 255, 255)";
          position = "0, 0";
          font_size = 12;
          halign = "left";
          valign = "bottom";
          shadow_passes = 1;
        }
      ];

      input-field = [
        {
          halign = "center";
          valign = "bottom";
          size = "250, 40";
          position = "0, 80";
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

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pgrep hyprlock || ${hyprlock}"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "${loginctl} lock-session"; # lock before suspend.
          after_sleep_cmd = "${hyprctl} dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = timeUntilLock;
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = timeUntilScreenOff;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = timeUntilSuspend;
            on-timeout = "${systemctl} suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
