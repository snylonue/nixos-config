{ pkgs, specialArgs, ... }:

let inherit (specialArgs) inputs;
in {
  imports = [ ./../home ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "minami";
    homeDirectory = "/home/minami";

    packages = let
      system-manager =
        inputs.system-manager.packages.x86_64-linux.system-manager;
    in [ system-manager ] ++ (with pkgs; [
      sing-box
      # xray
      tuic
    ]);
  };

  services.tuic.enable = false;

  targets.genericLinux.enable = true;
}
