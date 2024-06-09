{ pkgs, specialArgs, ... }:

let inherit (specialArgs) inputs;
in {
  imports = [ ./../home ./../modules/home/tuic.nix ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "shinobu";
    homeDirectory = "/home/shinobu";

    packages = with pkgs; [
      sing-box
      tuic
      miniserve
      inputs.system-manager.packages.x86_64-linux.system-manager
    ];
  };

  # services.sing-box.enable = true;
  services.tuic.enable = true;

  targets.genericLinux.enable = true;
}
