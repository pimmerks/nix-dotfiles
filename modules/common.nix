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

    kitty
  ];

  # # Install fonts
  # fonts.packages = with pkgs; [
  #   font-awesome
  #   (nerdfonts.override { fonts = [ "Meslo" "FiraCode" "JetBrainsMono" ]; })
  # ];
}
