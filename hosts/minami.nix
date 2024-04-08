{ config, pkgs, specialArgs, ... }:

let inputs = specialArgs; in
{
  imports = [ ./../home ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "minami";
    homeDirectory = "/home/minami";

    packages = with pkgs; [
      sing-box
      # xray
      tuic
      inputs.system-manager.packages.x86_64-linux.system-manager
    ];
  };

  services.tuic.enable = true;

  targets.genericLinux.enable = true;
}
