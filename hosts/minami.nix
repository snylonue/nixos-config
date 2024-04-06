{ config, pkgs, ... }:

{
  imports = [ ./../home ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "minami";
    homeDirectory = "/home/minami";

    packages = with pkgs; [
      # sing-box
      xray
      tuic
    ];
  };

  services.tuic.enable = true;

  targets.genericLinux.enable = true;
}
