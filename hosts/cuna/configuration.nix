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
      ];

      hashedPassword =
        "$y$j9T$A3ub0SmZZ1QziT7r4hcop0$UYfsky0k9kW0oSP2sqoXNSMqDy7LTWjSZy6AJjqg.r7";
    };
  };

  # system.copySystemConfiguration = true;

  networking = {
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    hostName = "cuna";
    domain = "cli.rs";
    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "142.171.135.73";
          prefixLength = 24;
        }];
      };
    };
    defaultGateway.address = "142.171.135.1";
  };

  system.stateVersion = "24.05";
}
