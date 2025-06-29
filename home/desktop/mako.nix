{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.libnotify];

  services.mako = {
    enable = true;
    settings = {
      font = "Source Sans Pro Semi-Bold 10";

      padding = "10,10";
      anchor = "top-right";

      default-timeout = 10000;
      layer = "overlay";

      # Colors https://github.com/catppuccin/mako/blob/main/src/latte
      background-color = "#eff1f5";
      text-color = "#4c4f69";
      border-color = "#1e66f5";
      progress-color = "over #ccd0da";
    };
  };
}
