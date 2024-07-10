{ pkgs, specialArgs, ... }:

let
  inherit (specialArgs) inputs;
  system-manager = inputs.system-manager.packages.default;
in {
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [ git helix fish fastfetch nixd nixfmt ])
    ++ [ system-manager ];

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
