{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [
    ripgrep
    bear
    gnumake
    gcc
  ];

  programs = {
    ripgrep.enable = true;
    git = {
      enable = true;
      userName = "snylonue";
      userEmail = "snylonue@gmail.com";
      extraConfig = {
        init = {
          defaultBranch = "master";
        };
        core = {
          editor = "vim";
        };
      };
    };
  };

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
