{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    go_1_26

    nodejs_22
    pnpm

    # python312

    # d2 for building diagrams
    d2

    # dotnet-sdk_9
  ];
}
