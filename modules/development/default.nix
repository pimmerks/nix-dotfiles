{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli_tools.nix
    ./languages.nix
    ./kubernetes.nix
  ];
}
