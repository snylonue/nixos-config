{ config, lib, pkgs, specialArgs, ... }:

let inputs = specialArgs.inputs;
in {
  imports = [ ./../../modules/system/xray.nix ];

  # workaround to make sops work
  options = {
    system = lib.mkOption { type = lib.types.raw; };

    services.openssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/nix-sops" ];
      secrets = {
        xray = {
          sopsFile = ./../../secrets/xray.json;
          format = "json";
        };
      };
    };

    environment = { systemPackages = with pkgs; [ xray ]; };

    services.xray = {
      enable = true;
      settingsFile = config.sops.secrets.xray.path;
    };
  };
}
