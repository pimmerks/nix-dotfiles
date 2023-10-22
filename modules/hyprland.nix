{ config, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
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

    # QT Wayland support
    #qt5-wayland
    #qt6-wayland

    kitty
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
