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
      # Resume from hibernate if swap file/device present
      resume.enable = true;
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

  # Microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributeOnLink;
  hardware.enableRedistributeOnLink = true;

  # Kernel modules loaded at boot
  boot.kernelModules = [ "kvm-intel" "thinkpad_acpi" ];
}