{
  description = "Home Manager configuration of vincentliu";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      mkHome =
        {
          system,
          username ? "vincentliu",
          homeDirectory ? (
            if nixpkgs.lib.hasSuffix "-darwin" system then "/Users/${username}" else "/home/${username}"
          ),
          dotfilesDirectory ? "${homeDirectory}/.dotfiles",
          additionalPkgs ? pkgs: nixpkgs.lib.optionals pkgs.hostPlatform.isLinux [ pkgs.zsh ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit additionalPkgs dotfilesDirectory;
          };
        };

    in
    {
      # Used by setup.sh's machine-local flake, without impure environment reads.
      lib.mkHome = mkHome;

      homeConfigurations = {
        "vincentliu" = mkHome { system = "aarch64-darwin"; };
        "vincentliu@x86_64-linux" = mkHome {
          system = "x86_64-linux";
          additionalPkgs =
            pkgs: with pkgs; [
              zsh
            ];
        };
        "vincentliu@aarch64-linux" = mkHome {
          system = "aarch64-linux";
          additionalPkgs =
            pkgs: with pkgs; [
              zsh
            ];
        };
      };
    };
}
