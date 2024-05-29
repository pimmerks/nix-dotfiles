{ pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; [
    (jetbrains.goland.overrideAttrs {
      version = "2024.1";
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-2024.1.tar.gz";
        sha256 = "783539f254e4d62f4fae153a9e737f1d69db1e44676c4d1513775571a68950e4";
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      version = "2024.1";
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-2024.1.tar.gz";
        sha256 = "d4c7cb7f1462c2b2bd9042b4714ab9de66c455ab9752c87698dc3902f0d49a2a";
      };
    })
  ];
}
