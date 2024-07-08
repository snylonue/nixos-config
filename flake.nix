{
  description = "snylonue's NixOS Flake";

  #nixConfig.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:snylonue/system-manager/pass-args";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/snylonue/nix-secrets";
      flake = false;
    };

    priv = {
      url = "path:./priv";
      flake = false;
    };
  };

  outputs = { ... }@inputs: {
    nixosConfigurations = let
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager;
    in {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.nixos = import ./hosts/nixos/home.nix;
            };
          }
        ];
      };
    };

    homeConfigurations = let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      home-manager = inputs.home-manager;
      mkHomeModule = modules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs modules;

          extraSpecialArgs = { inherit inputs; };
        };
    in {
      "shinobu" = mkHomeModule [ ./hosts/shinobu.nix ./modules/home/tuic.nix ];

      "minami" = mkHomeModule [
        ./hosts/minami.nix
        ./modules/home/tuic.nix
     ];

      "test11" = mkHomeModule [ ./hosts/test11.nix ];

      "marushiru" = mkHomeModule [ ./hosts/marushiru.nix ];
    };

    systemConfigs =
      let makeSystemConfig = inputs.system-manager.lib.makeSystemConfig;
      in {
        "marushiru" =
          makeSystemConfig { modules = [ ./system/marushiru.nix ]; };
        "minami" = makeSystemConfig {
          modules = [ ./system/minami ];
          extraSpecialArgs = {
            secrets = (import "${inputs.priv}/xray.nix") { };
          };
        };
      };

    formatter.x86_64-linux =
      inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
