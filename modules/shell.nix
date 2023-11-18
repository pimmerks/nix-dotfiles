{ config, pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-completions
  ];

  users.users.${user}.shell = pkgs.zsh;

  environment.sessionVariables.HIST_STAMPS = "yyyy-mm-dd";
  environment.sessionVariables.COMPLETION_WAITING_DOTS = "true";


  programs.zsh = {
    enable = true;
    histSize = 10000;
    shellAliases = {
      ssh = "kitten ssh";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "kubectl"
        "kubectx"
        # "kube-ps1"
        "helm"
        "golang"
        "git"
        "gitfast"
        "gitignore"
        "ng"
        "direnv"
        "fzf"
        "docker"
        "alias-finder"
        "aliases"
        "python"
        "pip"
        "pyenv"
        "colored-man-pages"
        "command-not-found"
        # "zsh-autosuggestions" # TODO
        # "zsh-completions" # TODO
        "1password"
        "macos"
        # "nvm" - Not needed
        "z"
        "systemadmin"
        "terraform"
        "aws"
        "argocd"
      ];
      customPkgs = [
        pkgs.zsh-completions
      ];
    };
  };
}
