{ pkgs, ... }:

{
  imports = [ ./sing-box ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [ git helix fish fastfetch nil nixfmt cachix ];

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
