{ user, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; [
    (jetbrains.goland.overrideAttrs {
      version = "2023.3.4";
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-2023.3.4.tar.gz";

        # curl https://download.jetbrains.com/go/goland-2023.3.4.tar.gz.sha256
        sha256 = "17c0f1142c65b0c27371691fe7f36bce66eca9779ec97266feaae0af3a0da10f";
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      version = "2023.3.4";
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-2023.3.4.tar.gz";

        # curl https://download.jetbrains.com/webstorm/WebStorm-2023.3.4.tar.gz.sha256
        sha256 = "236204a90d47e0dd25002078d3f032e51e03ce6bf214a78bebd28640bdd31908";
      };
    })
  ];
}
