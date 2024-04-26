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

  # hyprpaper systemd service
  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
