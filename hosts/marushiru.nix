{ config, pkgs, specialArgs, ... }:

let inherit (specialArgs) inputs;
in {
  imports = [ ./../home ];

  home = {
    username = "marushiru";
    homeDirectory = "/home/marushiru";

    packages = with inputs.system-manager.packages.x86_64-linux;
      [
        system-manager
        # nginx
      ];
  };

}
