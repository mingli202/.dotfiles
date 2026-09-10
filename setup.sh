#!/bin/bash

set -eo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# install nix if not already
if ! command -v nix >/dev/null 2>&1; then
	echo "nix not found, installing nix"
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
fi

# make a fresh Nix installation available in this shell
if ! command -v nix >/dev/null 2>&1; then
	if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
		. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
		. "$HOME/.nix-profile/etc/profile.d/nix.sh"
	fi
fi

if ! command -v nix >/dev/null 2>&1; then
	echo "nix is not available; restart your shell and rerun setup.sh" >&2
	exit 1
fi

# enable nix commands and flakes if not already configured
mkdir -p "$HOME/.config/nix"
if ! grep -qxF 'experimental-features = nix-command flakes' "$HOME/.config/nix/nix.conf" 2>/dev/null; then
	printf '\n%s\n' 'experimental-features = nix-command flakes' >>"$HOME/.config/nix/nix.conf"
fi

# use this repo as the default Home Manager configuration
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
hm_config="$config_dir/home-manager"
mkdir -p "$config_dir"
if [ ! -L "$hm_config" ] || [ "$(readlink "$hm_config")" != "$repo_dir/home-manager" ]; then
	if [ -e "$hm_config" ] || [ -L "$hm_config" ]; then
		backup_dir="$(mktemp -d "$hm_config.backup.XXXXXX")"
		mv "$hm_config" "$backup_dir/home-manager"
		echo "Existing Home Manager config backed up to $backup_dir/home-manager"
	fi
	ln -s "$repo_dir/home-manager" "$hm_config"
fi

# bootstrap directly from the repo, without generating a default configuration
if command -v home-manager >/dev/null 2>&1; then
	home-manager switch --flake "$repo_dir/home-manager" -b backup
else
	nix run github:nix-community/home-manager -- switch --flake "$repo_dir/home-manager" -b backup
fi
