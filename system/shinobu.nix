{ pkgs, specialArgs, ... }:

let
  nixos = specialArgs.nixosModulesPath;
  inherit (specialArgs) secrets;
  inherit (secrets) xray;
in {
  imports = [
    "${nixos}/services/networking/sing-box.nix"
    ./../modules/nixos/tuic.nix
    secrets.sing-box
  ];

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

      xray = {
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
            port = 9443;
            protocol = "vless";
            settings = {
              clients = [{
                id = xray.client_id;
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
                inherit (xray) shortIds privateKey;
              };
            };
            sniffing = {
              enabled = true;
              destOverride = [ "http" "tls" "quic" ];
            };
          }];

          outbounds = let mkOutbound = protocol: tag: { inherit protocol tag; };
          in [
            (mkOutbound "freedom" "direct")
            (mkOutbound "blackhole" "block")
          ];

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
  };
}
