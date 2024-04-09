{ config, lib, pkgs, ... }:
let cfg = config.services.tuic;
in {

  options = {
    services.tuic = {
      enable =
        lib.mkEnableOption (lib.mdDoc "Delicately-TUICed 0-RTT proxy protocol");

      package = lib.mkPackageOption pkgs "tuic" { };

      settingsFile = lib.mkOption {
        type = lib.types.path;
        default = "/usr/local/etc/tuic/config.json";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.tuic" pkgs
        lib.platforms.linux)
    ];

    systemd.user.services.tuic = {
      Install.WantedBy = [ "default.target" ];

      Unit = { After = "network.target nss-lookup.target"; };

      Service = {
        # User = "root";
        RestartSec = "10s";
        Restart = "on-failure";
        ExecStart = "${pkgs.tuic}/bin/tuic-server -c ${cfg.settingsFile}";
        ExecReload = "/bin/kill -HUP $MAINPID";
      };
    };
  };

}
