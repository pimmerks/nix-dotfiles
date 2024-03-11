{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.kitty
    pkgs.zsh-autosuggestions
    pkgs.fasd
  ];


#  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    autocd = true;

    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = false;
    };

#    plugins = [
#      {
#        # will source zsh-autosuggestions.plugin.zsh
#        name = "zsh-autosuggestions";
#        src = pkgs.fetchFromGitHub {
#          owner = "zsh-users";
#          repo = "zsh-autosuggestions";
#          rev = "v0.4.0";
#          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
#        };
#      }
#    ];

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
