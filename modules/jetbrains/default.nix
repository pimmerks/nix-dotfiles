{pkgs, ...}: {
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; let
    version = "2024.1.4";
    golandSha = "f982476c9d870f1f354ab15135094cbde5c25c851ec21f424d0cd24149a12be6";
    webstormSha = "d22f38c8c02520deef21a57f3c85800dcf44a2ace8174a6dd0daa0a2789d5657";
    pycharmSha = "043c33371cb5fb31fdeab6deccc809189efdc6d404f771c541d4dd779adcd2fa";
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
