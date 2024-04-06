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

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/2311.5.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations =
      let
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
      in
      {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.nixos = import ./home.nix;
              };
              # home-manager.extraSpecialArgs = inputs;
            }
          ];
        };
      };

    homeConfigurations =
      let
        system = "x86_64-linux";
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        home-manager = inputs.home-manager-unstable;
        mkHomeModule = modules: home-manager.lib.homeManagerConfiguration {
          inherit pkgs modules;

          extraSpecialArgs = inputs;
        };
      in
      {
        "shinobu" = mkHomeModule [ ./shinobu.nix ];

        "minami" = mkHomeModule [ ./minami.nix ];

        "test11" = mkHomeModule [ ./test11.nix ];

        "marushiru" = mkHomeModule [ ./marushiru.nix ];
      };

    systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
      modules = [
        ./module.nix
      ];
    };

    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
