{ config, lib, pkgs, ... }:
let
  cfg = config.services.tuic;
  settingsFormat = pkgs.formats.json { };
in
{

  options = {
    services.sing-box = {
      enable = lib.mkEnableOption (lib.mdDoc "Delicately-TUICed 0-RTT proxy protocol");

      package = lib.mkPackageOption pkgs "tuic" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = { };
        };
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.tuic" pkgs
        lib.platforms.linux)
    ];

    systemd.user.services.sing-box = {
      Install.WantedBy = [ "multi-user.target" ];

      Service = {
        RestartSec = "10s";
        Restart = "on-failure";
        ExecStart = "${pkgs.tuic}/bin/tuic-server -c /usr/local/etc/tuic/config.json";
        ExecReload = "/bin/kill -HUP $MAINPID";
      };
    };
  };

}
