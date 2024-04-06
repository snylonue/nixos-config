{ config, pkgs, ... }:

{
  imports = [ ./../home ];

  home = {
    username = "test11";
    homeDirectory = "/fsa/home/test11";

    packages = with pkgs; [
      ripgrep
    ];
  };
}
