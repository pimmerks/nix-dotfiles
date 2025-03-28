{
  config,
  lib,
  pkgs,
  user,
  homeDir,
  ...
}: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
  };

  # greeter
  services.xserver.displayManager.gdm.enable = lib.mkForce false;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --power-shutdown 'systemctl poweroff -i' --power-reboot 'systemctl reboot' --cmd Hyprland";
        #command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Window manager config
    waybar # Top bar
    wayland-utils
    wayland-protocols
    rofi-wayland # app launcher
    mako # Wayland notification daemon
    playerctl
    hyprland
    hyprpaper
    hyprpicker # Colorpicker
    pamixer # Provides volume control
    libnotify # Allows sending notifications
    wl-clipboard
    clipman
    cliphist
    sway-contrib.grimshot # Screenshot tool

    # Idle
    #swaylock
    swaylock-effects
    swayidle

    # xdg stuff for WM
    xdg-utils
    xdg-launch
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    dbus

    # Authentication agent
    libsForQt5.polkit-kde-agent

    # QT Wayland support
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    # File browsing + Gnome stuff
    nautilus
    file-roller
    eog # Image viewer
    gnome-font-viewer
    gnome-calculator
    gnome-system-monitor

    vlc # media player

    # Misc
    mangohud
  ];

  security.pam.services.hyprlock = {};

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    #extraPortals = with pkgs; [
    #  xdg-desktop-portal-gtk
    #  xdg-desktop-portal-gnome
    #];
  };
}
