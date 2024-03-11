{ config, pkgs, ... }:

{
  imports = [ ./home ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "shinobu";
  home.homeDirectory = "/home/shinobu";

  home.packages = with pkgs; [
    sing-box
    tuic
    miniserve
  ];

  # services.sing-box.enable = true;
  services.tuic.enable = true;

  targets.genericLinux.enable = true;
}
