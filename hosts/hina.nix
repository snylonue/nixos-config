{ pkgs, specialArgs, ... }:

let
  inherit (specialArgs) inputs;
  system-manager = inputs.system-manager.packages.x86_64-linux.system-manager;
in {
  home = {
    stateVersion = "24.05"; # Please read the comment before changing.
    packages = (with pkgs; [ git helix fish fastfetch nixd nixfmt ])
      ++ [ system-manager ];

    username = "shinobu";
    homeDirectory = "/home/shinobu";
  };

  programs = {
    fish.enable = true;
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "snylonue";
      userEmail = "snylonue@gmail.com";
      extraConfig = { init = { defaultBranch = "master"; }; };
    };
  };
}
