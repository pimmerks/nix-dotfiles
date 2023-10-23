{ pkgs, user, ... }:
{
  users.users.${user}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker.enable = true;
}
