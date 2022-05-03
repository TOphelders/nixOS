{
  description = "Nix system flake";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    stable.url = "github:NixOS/nixpkgs/nixos-21.11";

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    k9s.url = "github:derailed/k9s";
    k9s.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stable,
    unstable,
    neovim-nightly-overlay,
    k9s
  }:
  let
    pkgsCompat = import unstable {
      system = "x86_64-linux";
    };

    pkgsStable = import stable {
      system = "x86_64-linux";
    };

    specialArgs = {
      inherit home-manager;
    };

    homeConfigurations = {
      vm = home-manager.lib.homeManagerConfiguration rec {
        system = "x86_64-linux";
        extraSpecialArgs = specialArgs;
        pkgs = import unstable {
          inherit system;
        };
        homeDirectory = "/home/trevor";
        username = "trevor";
        configuration = { pkgs, config, ... }:
          {
            imports = [
              {
                nixpkgs.overlays = [
                  neovim-nightly-overlay.overlay
                  (self: super: rec { alacritty = pkgsCompat.alacritty; })
                ];

                nixpkgs.config = {
                  allowUnfree = true;
                };
              }
              ./hosts/home.nix
            ];
          };
      };
    };

    desktop =
      let
        system = "x86_64-linux";

        modules = [
          ./hosts/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config = {
              allowUnfree = true;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.verbose = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.trevor = import ./hosts/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      in
        unstable.lib.nixosSystem { inherit system modules specialArgs; };
  in
  {
    nixosConfigurations.nixos = desktop;
    inherit homeConfigurations;
  };
}
