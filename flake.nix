{
  description = "Nix system flake";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";

    master.url = "github:NixOS/nixpkgs/master";

    rust-overlay.url = "github:oxalica/rust-overlay";

    k9s.url = "github:derailed/k9s";
    k9s.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stable,
    unstable,
    master,
    rust-overlay,
    k9s
  }:
  let
    pkgsCompat = import unstable {
      system = "x86_64-linux";
    };

    pkgsStable = import stable {
      system = "aarch64-darwin";
    };

    pkgsMaster = import master {
      system = "aarch64-darwin";
    };

    specialArgs = {
      inherit home-manager;
      inherit pkgsMaster;
    };

    homeConfigurations = {
      mac = home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = specialArgs;
        pkgs = import unstable {
          system = "aarch64-darwin";
        };
        modules = [
          ./hosts/mac/home.nix
          {
            nixpkgs.overlays = [
              rust-overlay.overlays.default
            ];

            nixpkgs.config = {
              allowUnfree = true;
              packageOverrides = super: let self = super.pkgs; in {
                roboto-mono = self.nerdfonts.override {
                  fonts = [ "RobotoMono" ];
                };
              };
            };
          }
        ];
      };
    };

    desktop =
      let
        system = "x86_64-linux";

        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config = {
              allowUnfree = true;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.verbose = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.trevor = import ./hosts/desktop/home.nix;
            home-manager.extraSpecialArgs = specialArgs;

            home-manager.users.root.programs.git = {
              enable = true;
              extraConfig.safe.directory = "/home/trevor/src/nixOS";
            };
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
