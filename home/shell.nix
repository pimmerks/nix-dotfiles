{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.zsh-autosuggestions
    pkgs.fasd       # needed for 'z' jump-around
    pkgs.ripgrep    # Faster grep
    pkgs.fd         # Faster find
    pkgs.bat        # Better cat
    pkgs.difftastic # Better diffing
    pkgs.pre-commit # Pre-commit hooks for git repositories
  ];

  programs = {
    command-not-found = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      autocd = true;

      enableCompletion = true;
      enableVteIntegration = true;

      history = {
        size = 100000;
        share = false;
        ignoreDups = true;
        extended = true;
      };

      autosuggestion = {
        enable = true;
      };

      syntaxHighlighting = {
        enable = false;
      };

      shellAliases = {
        ll = "ls -alh";
        ".." = "cd ..";
        dc = "docker compose";

        # Alias cat to bat, but keep it mostly plain for easy copy/pasting etc
        "cat" = "bat --style=plain --paging=never";
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
#          "zsh-autosuggestions"
          "nvm"
          "1password"
          "macos"
          "direnv"
          "aws"
        ];
      };
    };
  };
}
