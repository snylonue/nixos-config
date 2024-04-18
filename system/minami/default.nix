{ config, lib, pkgs, specialArgs, ... }:

let
  nixos = specialArgs.nixosModulesPath;
  inherit (specialArgs) secrets;
in {
  imports = [ "${nixos}/services/networking/xray.nix" ];

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment = { systemPackages = with pkgs; [ xray ]; };

    services.xray = {
      enable = true;
      settings = {
        log.loglevel = "info";

        routing = {
          domainStrategy = "IPIfNonMatch";
          rules = [{
            type = "field";
            ip = [ "geoip:cn" "geoip:private" ];
            outboundTag = "block";
          }];
        };

        inbounds = [{
          listen = "0.0.0.0";
          port = 443;
          protocol = "vless";
          settings = {
            clients = [{
              id = secrets.client_id;
              flow = "xtls-rprx-vision";
            }];
            decryption = "none";
          };
          streamSettings = {
            network = "tcp";
            security = "reality";
            realitySettings = {
              show = false;
              dest = "www.universityofcalifornia.edu:443";
              xver = 0;
              serverNames = [
                "www.universityofcalifornia.edu"
                "workingsmarter.universityofcalifornia.edu"
                "universityofcalifornia.edu"
                "firstgen.universityofcalifornia.edu"
                "climate.universityofcalifornia.edu"
              ];
             inherit (secrets) shortIds privateKey;
            };
          };
          sniffing = {
            enabled = true;
            destOverride = [ "http" "tls" "quic" ];
          };
        }];

        outbounds = let mkOutbound = protocol: tag: { inherit protocol tag; };
        in [ (mkOutbound "freedom" "direct") (mkOutbound "blackhole" "block") ];

        policy = {
          levels = {
            "0" = {
              handshake = 2;
              connIdle = 120;
            };
          };
        };
      };
    };
  };
}
