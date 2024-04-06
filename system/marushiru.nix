{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment = {
      systemPackages = with pkgs; [
        nginx
      ];
    };

    services = {
      nginx = {
        enable = true;
        virtualHosts = {
          "reader2.minami-yume.com" = {
            # kTLS = true;
            onlySSL = true;
            serverName = "reader2.minami-yume.com";
            # sslTrustedCertificate = /home/marushiru/.acme.sh/reader2.minami-yume.com_ecc/ca.cer;
            sslCertificateKey = /home/marushiru/.acme.sh/reader2.minami-yume.com_ecc/reader2.minami-yume.com.key;
            sslCertificate = /home/marushiru/.acme.sh/reader2.minami-yume.com_ecc/reader2.minami-yume.com.cer;

            # listen = [
            #   {
            #     addr = "0.0.0.0";
            #     port = 8443;
            #     ssl = true;
            #   }
            #   {
            #     addr = "[::]";
            #     port = 8443;
            #     ssl = true;
            #   }
            # ];

            locations."/".extraConfig = ''
              proxy_pass  http://127.0.0.1:4396; #端口自行修改为映射端口
              proxy_http_version 1.1;
              proxy_cache_bypass $http_upgrade;
              proxy_set_header Upgrade           $http_upgrade;
              proxy_set_header Connection        "upgrade";
              proxy_set_header Host              $host;
              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host  $host;
              proxy_set_header X-Forwarded-Port  $server_port;
            '';
          };
        };
      };
    };
  };
}
