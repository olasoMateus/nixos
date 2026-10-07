{
  description = "NixOS configurations for aster (laptop) and polaris (server)";

  inputs = {
    # aster tracks unstable.
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # home-manager, used for managing user configuration.
    # Tracks master because nixpkgs above is unstable — there is no tagged
    # home-manager release matching an unreleased nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # polaris tracks stable. home-manager is pinned to the matching release,
    # otherwise its module set gets evaluated against a nixpkgs it was never
    # tested against.
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = inputs@{ self, ... }:
    let
      # Every host gets hosts/common plus its own hosts/<name> directory.
      # `nixpkgs` and `home-manager` are arguments so each host can sit on its
      # own channel.
      mkHost = { nixpkgs, home-manager, host }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/common
            ./hosts/${host}

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Back up pre-existing files that home-manager would otherwise
              # refuse to overwrite (e.g. leftover generated configs).
              home-manager.backupFileExtension = "hm-backup";
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        aster = mkHost {
          inherit (inputs) nixpkgs home-manager;
          host = "aster";
        };

        polaris = mkHost {
          nixpkgs = inputs.nixpkgs-stable;
          home-manager = inputs.home-manager-stable;
          host = "polaris";
        };
      };
    };
}
