#! /bin/sh
docker build . -t neovim
docker create -ti --name neovim neovim sh
docker cp neovim:/out/nvim.tar.gz .
docker cp neovim:/out/nvim-data.tar.gz .
docker rm -f neovim
