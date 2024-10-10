{ pkgs, specialArgs, ... }:

let inherit (specialArgs) inputs;
in {
  imports = [ ./../home ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "shinobu";
    homeDirectory = "/home/shinobu";

    packages = with pkgs; [
      sing-box
      miniserve
      inputs.system-manager.packages.x86_64-linux.system-manager
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  targets.genericLinux.enable = true;
}
