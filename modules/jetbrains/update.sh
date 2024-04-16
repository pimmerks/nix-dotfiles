#!/usr/bin/env zsh
PATH=$(dirname $0)
VERSION=$1

if [[ -z "$VERSION" ]]; then
  echo "Please supply a version number, for example:"
  echo "update.sh 2024.1"
  exit 1
fi

CURL=$(which curl)
AWK=$(which awk)

echo "Path: $PATH, $CURL, $AWK"
echo "Version: $VERSION"

GOLAND_SHA=$(curl -sS https://download.jetbrains.com/go/goland-$VERSION.tar.gz.sha256 | awk '{print $1}')
WEBSTORM_SHA=$(curl -sS https://download.jetbrains.com/webstorm/WebStorm-$VERSION.tar.gz.sha256 | awk '{print $1}')

printf "goland:

version = \"$VERSION\";
src = fetchurl {
  url = \"https://download.jetbrains.com/go/goland-$VERSION.tar.gz\";
  sha256 = \"$GOLAND_SHA\";
};\n"

printf "webstorm:

version = \"$VERSION\";
src = fetchurl {
  url = \"https://download.jetbrains.com/webstorm/WebStorm-$VERSION.tar.gz\";
  sha256 = \"$WEBSTORM_SHA\";
};\n"
