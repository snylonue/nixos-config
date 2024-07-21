{ config, lib, ... }:

{
  boot = {
    kernelParams = [ "audit=0" "net.ifnames=0" ];

    initrd = {
      compressor = "zstd";
      compressorArgs = [ "-19" "-T0" ];
      systemd.enable = true;

      postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        # Set the system time from the hardware clock to work around a
        # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
        # to the *boot time* of the host).
        hwclock -s
      '';

      availableKernelModules =
        [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" ];

      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
    };

    loader.grub = {
      enable = !config.boot.isContainer;
      default = "saved";
      devices = [ "/dev/vda" ];
    };
  };

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword =
        "$y$j9T$juYvLS4occFIwL1Z0OUnP1$iYiaTV6kSmi7B/RP2fhm5.doM3pebHXqDfrRXtEAUfD";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm0qs507HY6XdhU1m1zlLj49kqDpNEdf5V9rKb9lroo snylonue@gmail.com"
      ];
    };
  };

  networking = {
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    hostName = "hina";
  };

  services = {
    resolved.enable = false;
    openssh = {
      enable = true;
      ports = [ 2322 ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "prohibit-password";
      };
    };
  };

  system.stateVersion = "24.05";

  disko = {
    enableConfig = false;

    devices = {
      disk.main = {
        imageSize = "2G";
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 0;
            };

            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };

            nix = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
                mountOptions = [ "compress-force=zstd" "nosuid" "nodev" ];
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/vda3";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "nosuid" "nodev" ];
    };

    "/boot" = {
      device = "/dev/vda2";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
}
