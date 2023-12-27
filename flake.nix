{
  description = "snylonue's NixOS Flake";

  #nixConfig.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl/2311.5.3";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }@inputs: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nixos = import ./home.nix;
            # home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };

    homeConfigurations =
      let
        system = "x86_64-linux";
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        home-manager = home-manager-unstable;
      in
      {
        "shinobu" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./shinobu.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        "minami" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./minami.nix ];
        };
      };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
