# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixos-wsl, ... }:

{
  imports = [
    # include NixOS-WSL modules
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    helix
    man-pages
    man-pages-posix
    moreutils
    zip
    wineWowPackages.full
    winetricks
    fastfetch
    nil
    direnv
    bottles
    nixfmt
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "nixos" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
  # nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  programs = {
    fish.enable = true;
    direnv.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
  };

  services.xserver.enable = true;

  fonts = {
    packages = with pkgs; [
      source-sans
      source-serif
      source-han-sans
      source-han-serif
    ];
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    pulseaudio = {
      support32Bit = true;
      extraConfig = "load-module module-combine-sink";
    };
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.EUC-JP/EUC-JP" ];

  users = {
    defaultUserShell = pkgs.fish;
    extraUsers.nixos.extraGroups = [ "audio" ];
  };

  networking.proxy.default = "http://172.18.96.1:10811";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
