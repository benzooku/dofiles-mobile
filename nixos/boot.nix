# =============================================================================
#  Boot — systemd-boot, kernel, microcode, fwupd
# =============================================================================
{ config, pkgs, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # Latest stable kernel — good for Kaby Lake R + Thunderbolt support
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      # Hibernation resume: NOT enabled. With zram-only swap there's no real
      # device to write the image to, so resume from hibernate can't work.
      # When you set up a real swap file on btrfs or a swap partition, add:
      #   boot.resumeDevice = "/swap/swapfile";   # or /dev/disk/by-label/swap
      #   swapDevices = [ { device = "/swap/swapfile"; size = 8192; } ];
      # and the systemd initrd will pick it up automatically (no .enable flag).
      availableKernelModules = [
        "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];
    };

    # Console on TTYs at boot
    consoleLogLevel = 0;

    # Slightly cleaner Plymouth-less boot
    plymouth.enable = false;

    # Extra kernel cmdline (T480s: enable hibernation + quiet)
    kernelParams = [
      "mem_sleep_default=deep"
      "quiet"
      "splash"
      "boot.shell_on_fail"
    ];

    # tmpfs tweaks (faster build, larger shm)
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  # Firmware updates via LVFS (handles T480s BIOS, Thunderbolt, etc.)
  services.fwupd.enable = true;

  # Microcode updates (loads Intel CPU microcode at boot)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  # Enables redistributable firmware (linux-firmware, etc.) — required for
  # Intel WiFi/Bluetooth on T480s. If you also want unfree firmware blobs,
  # set hardware.enableAllFirmware = true; (and allow unfree in nix.settings).
  hardware.enableRedistributableFirmware = true;

  # Kernel modules loaded at boot
  boot.kernelModules = [ "kvm-intel" "thinkpad_acpi" ];
}