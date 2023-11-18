{ config, pkgs, user, homeDir, ... }:
{

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs = {
    hyprland = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Window manager config
    waybar # Top bar
    wayland-utils
    wayland-protocols
    rofi # Menu bar
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
    #qt5-wayland
    #qt6-wayland

    kitty

    # File browsing + Gnome stuff
    gnome.nautilus
    gnome.file-roller
    gnome.eog # Image viewer
    gnome.gnome-font-viewer
    gnome.gnome-calculator
    gnome.gnome-system-monitor

    # Misc
    mangohud
  ];

  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    #extraPortals = with pkgs; [
    #  xdg-desktop-portal-gtk
    #  xdg-desktop-portal-gnome
    #];
  };
}
