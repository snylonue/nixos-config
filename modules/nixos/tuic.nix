{ config, lib, pkgs, ... }:

{
  options = {
    services.tuic-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run tuic server.

          Either `settingsFile` or `settings` must be specified.
        '';
      };

      package = lib.mkPackageOption pkgs "tuic" { };

      settingsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/usr/tuic/config.json";
      };

      settings = lib.mkOption {
        type = lib.types.nullOr (lib.types.attrsOf lib.types.unspecified);
        default = null;
      };
    };

  };

  config = let
    cfg = config.services.tuic-server;
    settingsFile = if cfg.settingsFile != null then
      cfg.settingsFile
    else
      pkgs.writeTextFile {
        name = "tuic-server.json";
        text = builtins.toJSON cfg.settings;
      };

  in lib.mkIf cfg.enable {
    assertions = [{
      assertion = (cfg.settingsFile == null) != (cfg.settings == null);
      message =
        "Either but not both `settingsFile` and `settings` should be specified for tuic.";
    }];

    systemd.services.tuic-server = {
      description = "tuic server Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/tuic-server --config ${settingsFile}";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
      };
    };
  };
}
