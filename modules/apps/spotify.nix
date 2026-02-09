{
  user,
  pkgs,
  stablePkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with stablePkgs; [
    spotify
  ];
}
