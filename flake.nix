{
  description = "My dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [ ];
        flake = { };
        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];
        perSystem = { config, pkgs, ... }: {
          devShells = {
            default = pkgs.mkShell {
              packages =
                with pkgs;
                [
                  hello

                  # general tools
                  git
                  tmux

                  ripgrep
                  zoxide
                  fd
                  eza
                  starship
                  neovim

                  # package managers
                  uv
                  bun

                  # languages

                  # other libs
                  pkg-config

                  # formatters
                  nixfmt
                ]
                ++ lib.optionals stdenv.hostPlatform.isLinux [
                  zsh
                ];

              shellHook = "zsh";
            };
          };
        };
      }
    );

}
