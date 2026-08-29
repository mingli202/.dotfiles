FROM m.daocloud.io/docker.io/nixos/nix:latest@sha256:7a007c766426c1877758ddc5cb87a965ac131fc78c582ce0083d922d51ae945c

RUN echo "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org" \
	>> /etc/nix/nix.conf

RUN mkdir -p ~/.config/nix
RUN echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

RUN git config --global \
	url."https://gh-proxy.com/https://github.com/".insteadOf \
	"https://github.com/"

WORKDIR /.dotfiles

COPY . .

WORKDIR /.dotfiles

RUN nix build \
	./home-manager#homeConfigurations.root.activationPackage \
	--no-write-lock-file

RUN ./result/activate

RUN if [[ ! -d "$HOME/.config/nvim" ]]; then \
	git clone https://github.com/mingli202/nvim_config.git ~/.config/nvim \
	fi

