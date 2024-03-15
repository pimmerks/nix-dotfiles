{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    curl
    wget
    git
    tmux
    jq
    yq
    tree
    glances
    watch
    htop
    killall
    neofetch
    fzf # Command line fuzzy finder (also used in zsh)
    unzip
    gotop
    home-manager
    dig

    kitty

    home-manager

    # Programs I use:
    spotify
    discord
    signal-desktop
    chromium
  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      freefont_ttf
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      liberation_ttf
      unifont
      noto-fonts-color-emoji
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "Meslo" "FiraCode" "JetBrainsMono" ]; })
    ];
  };
}
