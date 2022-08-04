FROM ubuntu:14.04

RUN apt update -y
RUN apt install -y build-essential software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt update -y
RUN apt install -y ninja-build gettext libtool autoconf automake pkg-config unzip curl doxygen git tar make zip
RUN apt install -y gcc-9 g++-9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9

WORKDIR /tmp

RUN curl -OL https://github.com/Kitware/CMake/releases/download/v3.22.5/cmake-3.22.5-linux-x86_64.tar.gz
RUN tar -xf cmake-3.22.5-linux-x86_64.tar.gz

RUN curl -OL https://nodejs.org/dist/v16.16.0/node-v16.16.0-linux-x64.tar.xz
RUN tar -xf node-v16.16.0-linux-x64.tar.xz

RUN curl -OL https://github.com/ninja-build/ninja/releases/download/v1.11.0/ninja-linux.zip
RUN mkdir -p /usr/local/bin
RUN unzip ninja-linux.zip -d /usr/local/bin

ENV PATH="${PATH}:/tmp/node-v16.16.0-linux-x64/bin:/tmp/cmake-3.22.5-linux-x86_64/bin:/nvim/bin"


RUN git clone https://github.com/neovim/neovim --depth=1

WORKDIR /tmp/neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/nvim install

WORKDIR /root
RUN git clone https://github.com/Dephilia/nvim.git /root/.config/nvim --depth=1

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim /root/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN yes | nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; exit 0
RUN nvim --headless -c "LspInstall --sync pyright clangd sumneko_lua rust_analyzer bashls html tsserver" -c q; exit 0

WORKDIR /out

RUN cd / ;tar zcf nvim.tar.gz nvim; mv nvim.tar.gz /out
RUN cd /root; tar zcf nvim-data.tar.gz .config/nvim .local/share/nvim; mv nvim-data.tar.gz /out

RUN rm -rf /tmp
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/tmp/node-v16.16.0-linux-x64/bin:/tmp/cmake-3.22.5-linux-x86_64/bin:/nvim/bin"

WORKDIR /root
