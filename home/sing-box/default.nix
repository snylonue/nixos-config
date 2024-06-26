{ config, lib, pkgs, ... }:
let
  cfg = config.services.sing-box;
  settingsFormat = pkgs.formats.json { };
in {

  options = {
    services.sing-box = {
      enable =
        lib.mkEnableOption (lib.mdDoc "sing-box universal proxy platform");

      package = lib.mkPackageOption pkgs "sing-box" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            route = {
              geoip.path = lib.mkOption {
                type = lib.types.path;
                default = "${pkgs.sing-geoip}/share/sing-box/geoip.db";
                defaultText = lib.literalExpression
                  "\${pkgs.sing-geoip}/share/sing-box/geoip.db";
                description = lib.mdDoc ''
                  The path to the sing-geoip database.
                '';
              };
              geosite.path = lib.mkOption {
                type = lib.types.path;
                default = "${pkgs.sing-geosite}/share/sing-box/geosite.db";
                defaultText = lib.literalExpression
                  "\${pkgs.sing-geosite}/share/sing-box/geosite.db";
                description = lib.mdDoc ''
                  The path to the sing-geosite database.
                '';
              };
            };
          };
        };
        default = { };
        description = lib.mdDoc ''
          The sing-box configuration, see https://sing-box.sagernet.org/configuration/ for documentation.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.sing-box" pkgs
        lib.platforms.linux)
    ];

    systemd.user.services.sing-box = {
      Install.WantedBy = [ "multi-user.target" ];

      Service = {
        RestartSec = "10s";
        Restart = "on-failure";
        ExecStart =
          "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -C /etc/sing-box run";
        ExecReload = "/bin/kill -HUP $MAINPID";
      };
    };
  };

}
