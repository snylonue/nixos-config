{ pkgs, specialArgs, ... }:

let nixos = specialArgs.nixosModulesPath;
in {
  imports = [ "${nixos}/services/web-servers/caddy" ];

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment = { systemPackages = with pkgs; [ caddy vaultwarden ]; };

    services = let vaultwarden_port = 8222;
    in {
      caddy = {
        enable = true;

        virtualHosts = {
          "vaultwarden.minami-yume.com".extraConfig =
            "reverse_proxy http://127.0.0.1:${vaultwarden_port}";
        };
      };

      vaultwarden = {
        enable = true;

        config = {
          DOMAIN = "https://vaultwarden.minami-yume.com";

          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = vaultwarden_port;
        };
      };
    };
  };
}
