FROM m.daocloud.io/docker.io/nixos/nix:latest@sha256:7a007c766426c1877758ddc5cb87a965ac131fc78c582ce0083d922d51ae945c


RUN echo "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org" \
	>> /etc/nix/nix.conf

WORKDIR /app

RUN mkdir -p ~/.config/nix
RUN echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

ARG NIXPKGS_REV
ARG FLAKE_PARTS_REV
ARG NIXPKGS_LIB_REV

COPY flake.nix flake.lock ./

RUN nix develop \
	--override-input nixpkgs \
	"https://gh-proxy.com/https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz" \
	--override-input flake-parts \
	"https://gh-proxy.com/https://github.com/hercules-ci/flake-parts/archive/${FLAKE_PARTS_REV}.tar.gz" \
	--override-input flake-parts/nixpkgs-lib \
	"https://gh-proxy.com/https://github.com/nix-community/nixpkgs.lib/archive/${NIXPKGS_LIB_REV}.tar.gz" \
	--command true

RUN mkdir -p ~/.dotfiles
COPY . ~/.dotfiles

RUN git config --global \
	url."https://gh-proxy.com/https://github.com/".insteadOf \
	"https://github.com/"

RUN git clone https://github.com/mingli202/nvim_config.git ~/.config/nvim
