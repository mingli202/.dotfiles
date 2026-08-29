#!/bin/bash

# installs home-manager as a standalone installation and build + activate the derivation
# also clones my nvim config if not already made

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch --flake ./home-manager/

if [[ ! -d "$HOME/.config/nvim" ]]; then
	git clone https://github.com/mingli202/nvim_config.git ~/.config/nvim
fi
