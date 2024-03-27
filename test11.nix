{ config, pkgs, ... }:

{
  home = {
    username = "test11";
    homeDirectory = "/fsa/home/test11";

    packages = with pkgs; [
      helix
      fastfetch
      ripgrep
    ];

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
