{ pkgs, specialArgs, ... }:

let inherit (specialArgs) secrets;
in {
  imports = [ ./../modules/nixos/tuic.nix secrets.sing-box ];

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    system-manager.allowAnyDistro = true;

    environment = { systemPackages = with pkgs; [ tuic sing-box ]; };

    services = {
      sing-box = {
        settings = {
          inbounds = [{
            type = "hysteria2";
            listen = "::";
            listen_port = 8080;
            ignore_client_bandwidth = true;
          }];
        };
      };

      tuic-server = {
        enable = true;
        settingsFile = "/usr/local/etc/tuic/config.json";
      };
    };
  };
}
