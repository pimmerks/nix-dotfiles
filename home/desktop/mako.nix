{ config, pkgs, ... }: {
  home.packages = [ pkgs.libnotify ];

  services.mako = {
    enable = true;
    font = "Source Sans Pro Semi-Bold 10";

    padding = "10,10";
    anchor = "top-right";

    defaultTimeout = 10000;
    layer = "overlay";

    # Colors https://github.com/catppuccin/mako/blob/main/src/latte
    backgroundColor = "#eff1f5";
    textColor = "#4c4f69";
    borderColor = "#1e66f5";
    progressColor = "over #ccd0da";
  };
}
