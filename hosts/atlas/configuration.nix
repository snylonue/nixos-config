{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh = {
    # permitRootLogin = "yes";
    enable = true;
  };

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        # change this to your ssh key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9hqofNQMF58Q+lfhvXzhjGvIrDyPONxFKYw6H5s3HM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkWvKseKN2GrOYzSosUuzZ5K/pkwsVlc9kZHpewa2v5"
      ];

      hashedPassword =
        "$y$j9T$fa34jqlHSSZpI1TCMcj/d/$13k0yNAAsu8r/7uLeVRQ6omFB1qBwiGlIeym8pG3GK1";
    };
  };

  # system.copySystemConfiguration = true;

  networking = {
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "24.05";
}
