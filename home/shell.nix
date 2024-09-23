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

    tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 5000;
      terminal = "xterm-256color";
      keyMode = "vi";
      customPaneNavigationAndResize = true;

      # Split and open in current directory.
      extraConfig = ''
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -hc "#{pane_current_path}"
        # bind c new-window -c "#{pane_current_path}"
      '';

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_status_modules_left "null"
            set -g @catppuccin_status_modules_right "directory session date_time"

            set -g @catppuccin_status_left_separator  ""
            set -g @catppuccin_status_right_separator " "
            set -g @catppuccin_status_fill "all"
            set -g @catppuccin_status_connect_separator "yes"

            set -g @catppuccin_icon_window_last "󰖰"
            set -g @catppuccin_icon_window_current "󰖯"
            set -g @catppuccin_icon_window_zoom "󰁌"
            set -g @catppuccin_icon_window_mark "󰃀"
            set -g @catppuccin_icon_window_silent "󰂛"
            set -g @catppuccin_icon_window_activity "󱅫"
            set -g @catppuccin_icon_window_bell "󰂞"

            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_text "#W"

            # set -g @catppuccin_window_left_separator "█"
            # set -g @catppuccin_window_right_separator "█ "
            # set -g @catppuccin_window_number_position "right"
            # set -g @catppuccin_window_middle_separator "  █"

            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator ""
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_middle_separator ""

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_current_fill "number"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
      ];
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
        tf = "terraform";

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
