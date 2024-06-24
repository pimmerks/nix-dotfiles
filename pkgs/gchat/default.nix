{
  pkgs,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  electron,
  glib,
}: let
  version = "5.29.23-1";
  icon = "google-chat-linux";
  # electron = electron_24;
in
  buildNpmPackage rec {
    pname = "google-chat-linux";
    inherit version;
    src = fetchFromGitHub {
      owner = "squalou";
      repo = "google-chat-linux";
      rev = version;
      hash = "sha256-JBjxZUs0HUgAkJJBYhNv2SHjpBtAcP09Ah4ATPwpZsQ";
    };

    npmDepsHash = "sha256-7lKWbXyDpYh1sP9LAV/oA7rfpckSbIucwKT21vBrJ3Y";
    npmBuildScript = "dist";
    buildInputs = [glib];
    nativeBuildInputs = [makeWrapper copyDesktopItems];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    postPatch = ''
      substituteInPlace src/paths.js --replace process.resourcesPath "\"$out/opt/google-chat-linux/resources\""
    '';

    buildPhase = ''
      runHook preBuild

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron}/libexec/electron \
        -c.electronVersion=${electron.version}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out

      pushd dist/linux-unpacked
      mkdir -p $out/opt/google-chat-linux
      cp -r locales resources{,.pak} $out/opt/google-chat-linux
      popd

      makeWrapper '${electron}/bin/electron' "$out/bin/google-chat-linux" \
        --add-flags $out/opt/google-chat-linux/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set ELECTRON_FORCE_IS_PACKAGED true \
        --set-default ELECTRON_IS_DEV 0 \
        --set-default NODE_ENV production \
        --inherit-argv0

      install -Dm644 "build/icons/256.png" "$out/share/icons/hicolor/256x256/apps/${icon}.png"
      install -Dm644 "build/icons/64.png" "$out/share/icons/hicolor/64x64/apps/${icon}.png"
      install -Dm644 "build/icons/48.png" "$out/share/icons/hicolor/48x48/apps/${icon}.png"
      install -Dm644 "build/icons/icon.png" "$out/share/pixmaps/${icon}.png"

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "google-chat-linux";
        icon = icon;
        exec = "google-chat-linux %U";
        comment = "Unofficial Google Chat Electron app";
        desktopName = "Google Chat Linux";
        categories = ["Application"];
      })
    ];

    meta = with lib; {
      description = "Unofficial electron-based desktop client for Google Chat, electron included";
      homepage = "https://github.com/squalou/google-chat-linux";
      mainProgram = "google-chat-linux";
#      license = licenses.unfree;
      platforms = platforms.linux;
    };
  }
