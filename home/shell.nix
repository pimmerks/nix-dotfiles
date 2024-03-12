{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.zsh-autosuggestions
    pkgs.fasd
  ];

#  home.sessionVariables = {
#    EDITOR = "nvim";
#  };

  programs.zsh = {
    enable = true;
    autocd = true;

    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = false;
    };

    shellAliases = {
      ll = "ls -alh";
      ".." = "cd ..";
      vim = "nvim";
    };

    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = [
        "git"
        "kubectl"
        "kubectx"
        "helm"
        "gitfast"
        "gitignore"
        "fasd"
        "fzf"
        "docker"
        "alias-finder"
        "aliases"
        "colored-man-pages"
        "command-not-found"
#        "zsh-autosuggestions"
        "nvm"
        "1password"
        "macos"
        "direnv"
        "aws"
      ];
    };
  };
}
