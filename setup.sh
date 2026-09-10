#!/bin/bash

# install nix if not already
if ! command -v nix >/dev/null 2>&1; then
	echo "nix not found, installing nix"
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
fi

# enable nix commands and flakes if not already configured
mkdir -p "$HOME/.config/nix"
if ! grep -qxF 'experimental-features = nix-command flakes' "$HOME/.config/nix/nix.conf" 2>/dev/null; then
	printf '\n%s\n' 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"
fi

# installs home-manager as a standalone installation and build + activate the derivation
if ! command -v home-manager >/dev/null 2>&1; then
	echo "home-manager not found, installing home-manager from master"

	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	home-manager switch --flake ./home-manager/
fi
