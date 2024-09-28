{ pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

environment.systemPackages = with pkgs; let
    version = "2024.2.1";
    golandSha = "46bebbbef4e34e8e38fe971473153527a1de6bfc5162176aec528e71b1c2a115";
    webstormSha = "a598c2686a6c8e4d6b19e1a0a54c78c2c77a772c35ef041244fece64940d8b93";
    pycharmSha = "232ddc3c15b138264534820a40049ea4b0108647ba2972294616bc2a3f22234b";
  in [
    (jetbrains.goland.overrideAttrs {
      inherit version;
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-${version}.tar.gz";
        sha256 = golandSha;
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      inherit version;
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
        sha256 = webstormSha;
      };
    })

    (jetbrains.pycharm-community.overrideAttrs {
      inherit version;
      src = fetchurl {
        url = "https://download-cdn.jetbrains.com/python/pycharm-community-${version}.tar.gz";
        sha256 = pycharmSha;
      };
    })
  ];
}
