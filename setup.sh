#!/bin/bash

# install nix if not already
if ! command -v nix >/dev/null 2>&1; then
	echo "nix not found, installing nix"
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
fi

# installs home-manager as a standalone installation and build + activate the derivation
if ! command -v home-manager >/dev/null 2>&1; then
	echo "home-manager not found, installing home-manager from master"

	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	home-manager switch --flake ./home-manager/
fi

# clones nvim config if not already
if [[ ! -d "$HOME/.config/nvim" ]]; then
	echo "cloning nvim config"
	git clone https://github.com/mingli202/nvim_config.git ~/.config/nvim
fi

# clones tmux package manager if not already
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
	echo "cloning tmux package manager"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
