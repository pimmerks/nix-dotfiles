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
in
{
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = timeUntilLock - timeUntilScreenOff;
        ignore_empty_input = true;
        no_fade_out = true; # bit buggy, so disable it
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

      label = [
        {
          monitor = "";
          size = "200, 50";
          text = "cmd[update:1000] date +%T";
          color = "rgb(255, 255, 255)";
          position = "0, 0";
          halign = "center";
          valign = "center";
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
        general = let
          grim = "${pkgs.grim}/bin/grim";
          screenshotFiles = {
            left = "/tmp/lockscreen-left.png";
            right = "/tmp/lockscreen-right.png";
          };

          # https://github.com/hyprwm/hyprlock/issues/59#issuecomment-2023025535
          # Need to take a screenshot with `grim` before idling
          hyprlockCmd = "${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${pkgs.hyprlock}/bin/hyprlock";
         in {
          lock_cmd = "pidof hyprlock || ${hyprlockCmd}"; # avoid starting multiple hyprlock instances.
          unlock_cmd = "rm -rf ${screenshotFiles.left} ${screenshotFiles.right}";
          before_sleep_cmd = "${loginctl} lock-session";   # lock before suspend.
          after_sleep_cmd = "${hyprctl} dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          # TODO: Add screen dimming
          {
            timeout = timeUntilLock;
            on-timeout = "${loginctl} lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = timeUntilScreenOff;
            on-timeout = "${hyprctl} dispatch dpms off";  # screen off when timeout has passed
            on-resume = "${hyprctl} dispatch dpms on";    # screen on when activity is detected after timeout has fired.
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
