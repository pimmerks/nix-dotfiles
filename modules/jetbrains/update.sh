#!/usr/bin/env bash
VERSION=$1

if [[ -z "$VERSION" ]]; then
  echo "Please supply a version number, for example:"
  echo "update.sh 2024.1"
  exit 1
fi

echo "Version: $VERSION"

GOLAND_SHA=$(curl -sS https://download.jetbrains.com/go/goland-$VERSION.tar.gz.sha256 | awk '{print $1}')
WEBSTORM_SHA=$(curl -sS https://download.jetbrains.com/webstorm/WebStorm-$VERSION.tar.gz.sha256 | awk '{print $1}')
PYCHARM_SHA=$(curl -sS https://download-cdn.jetbrains.com/python/pycharm-community-$VERSION.tar.gz.sha256 | awk '{print $1}')

printf "
  environment.systemPackages = with pkgs; let
    version = \"$VERSION\";
    golandSha = \"$GOLAND_SHA\";
    webstormSha = \"$WEBSTORM_SHA\";
    pycharmSha = \"$PYCHARM_SHA\";
"
