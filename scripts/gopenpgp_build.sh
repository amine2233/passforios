#!/bin/bash

set -euox pipefail

export GOPATH="$(pwd)/go"
export PATH="$PATH:$GOPATH/bin"
export ANDROID_NDK_HOME="/opt/homebrew/share/android-ndk"

PACKAGE_VERSION="master"
PACKAGE_PATH="github.com/ProtonMail/gopenpgp"
GOPENPGP_REVISION="gnu-dummy"
OUTPUT_PATH="$GOPATH/dist"

rm -rf "$GOPATH/src"
mkdir -p "$GOPATH"

go install golang.org/x/mobile/cmd/gomobile@latest || true
go install golang.org/x/mobile/cmd/gobind@latest || true

git clone https://github.com/ProtonMail/gopenpgp.git "$GOPATH/src/$PACKAGE_PATH"

( cd "$GOPATH/src/$PACKAGE_PATH" && sh build.sh )

mkdir -p "$OUTPUT_PATH"

"$GOPATH/bin/gomobile" bind -v -ldflags="-s -w" -target ios -o "${OUTPUT_PATH}/Crypto.framework" \
    "$PACKAGE_PATH"/{crypto,armor,constants,models,subtle}
