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
          additionalPkgs ? pkgs: [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit additionalPkgs;
          };
        };

    in
    {
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
