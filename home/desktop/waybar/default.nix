{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

#        height = 49;
        spacing = 1;
        gtk-layer-shell = true;

        #
        # Left modules
        #
        modules-left = ["hyprland/workspaces" "wlr/taskbar"];
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "wlr/taskbar" = {
          on-click = "activate";
        };

        #
        # Center modules
        #
        modules-center = ["hyprland/window"];
        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
          rewrite = {
            "^(.*) — Mozilla Firefox$" = " $1";
          };
        };

        #
        # Right modules
        #
        modules-right = [
          "tray"
          "temperature"
          "cpu"
          "memory"
          "pulseaudio#microphone"
          "pulseaudio#audio"
          "idle_inhibitor"
          "gamemode"
          "clock"
        ];

        tray = {
          spacing = 10;
        };

        temperature = {
          format = " {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        };

        cpu = {
          format = "󰻠 {usage}%";
          on-click = "";
          tooltip = false;
        };

        memory = {
          format = "󰍛 {percentage}%";
          on-click = "";
          tooltip = false;
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          max-volume = 100;
          tooltip = false;
        };

        "pulseaudio#audio" = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 {volume}%";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾" ];
          };
          tooltip = true;
          tooltip-format = "{icon} {desc}";
          on-click = "~/.config/waybar/scripts/audio_output_changer.py";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        gamemode = {
          format = "{glyph}";
          format-alt = "{glyph} {count}";
          glyph = "";
          hide-not-running = true;
          use-icon = true;
          icon-name = "input-gaming-symbolic";
          icon-spacing = 4;
          icon-size = 20;
          tooltip = true;
          tooltip-format = "Games running: {count}";
        };

        clock = {
          interval = 1;
          format = "{:%d %b (W:%V) 󰥔 %H:%M:%S}";
          tooltip = true;
          tooltip-format = "{calendar}";
          calendar = {
            mode = "month";
            format = {
              today = "<span color=\"#0dbc79\">{}</span>";
            };
          };
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
