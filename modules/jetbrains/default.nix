{ user, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/ides.json
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/bin/versions.json
  # https://discourse.nixos.org/t/overriding-jetbrains-package-versions/6168/4

  environment.systemPackages = with pkgs; [
    (jetbrains.goland.overrideAttrs {
      version = "2023.3.6";
      src = fetchurl {
        url = "https://download.jetbrains.com/go/goland-2023.3.6.tar.gz";

        # curl https://download.jetbrains.com/go/goland-2023.3.6.tar.gz.sha256
        sha256 = "96fb4117d4aedd32ace976f48b6618fe30480b3fbfa81adfef963eb720a442e1";
      };
    })

    (jetbrains.webstorm.overrideAttrs {
      version = "2023.3.6";
      src = fetchurl {
        url = "https://download.jetbrains.com/webstorm/WebStorm-2023.3.6.tar.gz";

        # curl https://download.jetbrains.com/webstorm/WebStorm-2023.3.6.tar.gz.sha256
        sha256 = "deb38fe0f83a616cd07a2ec1243945ec15539c3d3a2e2f27294c5922737f0b5f";
      };
    })
  ];
}
