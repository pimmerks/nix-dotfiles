{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go_1_22

    nodejs_21

    python312
  ];
}
