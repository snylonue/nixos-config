{ pkgs, ... }:

{
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";

    packages = with pkgs; [ ripgrep bear gnumake gcc meson ninja gdb tokei ];

    stateVersion = "23.11";

  };

  programs = {
    ripgrep.enable = true;
    git = {
      enable = true;
      userName = "snylonue";
      userEmail = "snylonue@gmail.com";
      extraConfig = {
        init = { defaultBranch = "master"; };
        core = { editor = "vim"; };
      };
    };
    home-manager.enable = true;
  };
}
