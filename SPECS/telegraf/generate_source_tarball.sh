#!/bin/bash
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

set -e

get_param() {
    if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        echo "$2"
    else
        echo "Error: argument for ($1) is missing." >&2
        return 1
    fi
}

PKG_VERSION=""
SRC_TARBALL=""
OUT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# parameters:
#
# --srcTarball  : src tarball file
# --outFolder   : folder where to copy the new tarball(s)
# --pkgVersion  : package version
#
while (( "$#" )); do
    case "$1" in
        --srcTarball)
        SRC_TARBALL="$(get_param "$1" "$2")"
        shift 2
        ;;
        --outFolder)
        OUT_FOLDER="$(get_param "$1" "$2")"
        shift 2
        ;;
        --pkgVersion)
        PKG_VERSION="$(get_param "$1" "$2")"
        shift 2
        ;;
        -*)
        echo "Error: unsupported flag $1." >&2
        exit 1
        ;;
  esac
done

echo "--srcTarball   -> $SRC_TARBALL"
echo "--outFolder    -> $OUT_FOLDER"
echo "--pkgVersion   -> $PKG_VERSION"

if [ -z "$PKG_VERSION" ]; then
    echo "Error: --pkgVersion parameter cannot be empty." >&2
    exit 1
fi

# if [ ! -f "$SRC_TARBALL" ]; then
#     echo "Error: --srcTarball is not a file." >&2
#     exit 1
# fi

# SRC_TARBALL="$(realpath "$SRC_TARBALL")"
# OUT_FOLDER="$(realpath "$OUT_FOLDER")"

echo "-- create temp folder"
TEMPDIR=$(mktemp -d)
function cleanup {
    echo "+++ cleanup -> remove $TEMPDIR"
    rm -rf $TEMPDIR
}
trap cleanup EXIT

echo "Starting telegraf source tarball creation"

NAME_VER="telegraf-$PKG_VERSION"
TELEGRAF_URL="https://github.com/influxdata/telegraf/archive/refs/tags/v$PKG_VERSION.tar.gz"

cd "$TEMPDIR"
wget -c $TELEGRAF_URL -O "$NAME_VER.tar.gz"
tar -xzf "$NAME_VER.tar.gz"
cd "$NAME_VER"
go mod vendor

cd "$TEMPDIR"
tar -czf "$OUT_FOLDER/$NAME_VER.tar.gz" "$NAME_VER"
echo "Source tarball $OUT_FOLDER/$NAME_VER.tar.gz successfully created!"