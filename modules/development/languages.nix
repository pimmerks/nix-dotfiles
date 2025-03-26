{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    go_1_24

    nodejs_22

    python312

    # d2 for building diagrams
    d2
  ];
}
