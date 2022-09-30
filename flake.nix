{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-modules = {
      url = "github:eliaslfox/nix-modules/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-modules }:
  let
    system = "x86_64-linux";

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ overlay-unstable ];
    };
  in {
    nixosConfigurations."thonkpod" = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = inputs;

      modules = [
        nix-modules.nixosModules.nix-modules {}

        ./configuration.nix
        ./machines/thinkpadX1.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
