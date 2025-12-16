#!/usr/bin/env bash

set -euo pipefail

TARGET_ARCH=${TARGET_ARCH:-"amd64"}
TARGET_OS=${TARGET_OS:-"linux"}

TERRAFMT_GIT_REPO=${TERRAFMT_GIT_REPO:-"https://github.com/katbyte/terrafmt"}
TERRAFMT_GIT_TAG=${TERRAFMT_GIT_TAG:-$(cat ./terrafmt-tag.txt)}
INITIAL_DIR=$(pwd)

echo "Building terrafmt version: $TERRAFMT_GIT_TAG for $TARGET_OS/$TARGET_ARCH"
mkdir -p "$INITIAL_DIR/output"

# create a temp dir for cloning and building
BUILD_DIR=$(mktemp -d)
echo "Using build directory: $BUILD_DIR"

cd "$BUILD_DIR"
echo "Cloning terrafmt repository..."
git clone --branch "$TERRAFMT_GIT_TAG" --depth 1 "$TERRAFMT_GIT_REPO" terrafmt
cd terrafmt

echo "Creating build output directory..."
mkdir ./output

echo "Building terrafmt..."
OUTPUT_FILE_NAME=terrafmt-${TERRAFMT_GIT_TAG}-${TARGET_OS}-${TARGET_ARCH}
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o ./output/$OUTPUT_FILE_NAME

echo "Moving built binary to output directory..."
mv ./output/$OUTPUT_FILE_NAME "$INITIAL_DIR/output/"

echo "Build complete. Binary located at: $INITIAL_DIR/output/$OUTPUT_FILE_NAME"
cd "$INITIAL_DIR"
