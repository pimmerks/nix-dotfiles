{ config, pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # misc
    tmux
    jq
    yq
    watch
    neofetch

    # monitoring
    htop
    glances
    gotop
    killall

    # fs
    unzip
    tree
    fzf

    # network
    curl
    wget
    dig
  ];
}
