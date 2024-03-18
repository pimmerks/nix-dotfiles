{ user, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; [
    (jetbrains.goland.overrideAttrs {
      version = "2023.3.5";
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-2023.3.5.tar.gz";

        # curl https://download.jetbrains.com/go/goland-2023.3.5.tar.gz.sha256
        sha256 = "bf4cacb8b9f2cc2bf5661d19f1e240debd978a6e043d7e3c2a26f0ba3b409487";
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      version = "2023.3.5";
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-2023.3.5.tar.gz";

        # curl https://download.jetbrains.com/webstorm/WebStorm-2023.3.5.tar.gz.sha256
        sha256 = "9a5a257a71f66daea9f57b638f96ec3a635d89ae4087f66f9fe65c20345344fb";
      };
    })
  ];
}
