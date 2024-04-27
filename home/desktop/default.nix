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

  systemd.user.services = {
    hyprpaper = {
      Unit = {
        Description = "Hyprpaper";
        PartOf = [ "hyprland-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = { WantedBy = [ "hyprland-session.target" ]; };
    };

    clipboard-history = {
      Unit = {
        Description = "Clipboard History";
        PartOf = [ "hyprland-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = { WantedBy = [ "hyprland-session.target" ]; };
    };

  };

}
