{ config, pkgs, ... }:

{
  imports = [ ./home ];

  home = {
    username = "marushiru";
    homeDirectory = "/home/marushiru";
  };
}
