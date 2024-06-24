{ user, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; [
    (jetbrains.goland.overrideAttrs {
      version = "2024.1.4";
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-2024.1.4.tar.gz";
        sha256 = "f982476c9d870f1f354ab15135094cbde5c25c851ec21f424d0cd24149a12be6";
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      version = "2024.1.4";
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-2024.1.4.tar.gz";
        sha256 = "d22f38c8c02520deef21a57f3c85800dcf44a2ace8174a6dd0daa0a2789d5657";
      };
    })
  ];
}
