#! /bin/sh
TARGET=$HOME

mkdir -p "$TARGET/.local"
tar xf nvim.tar.gz --strip-components=1 -C "$TARGET/.local"
tar xf nvim-data.tar.gz -C "$TARGET"
