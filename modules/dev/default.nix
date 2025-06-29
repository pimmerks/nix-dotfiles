{
  pkgs,
  unstablePkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with unstablePkgs; [
    # VCS
    pkgs.git

    # Editors
    vim
    neovim

    # Tools
    gnumake

    # misc
    tmux
    jq
    yq
    tree
    glances
    watch
    htop
    killall
    neofetch
    fzf
    unzip
    gotop

    # network
    pkgs.curl
    wget
    dig
  ];
}

