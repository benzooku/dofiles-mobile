# =============================================================================
#  Power — TLP, thermald, power-profiles-daemon, upower, logind
#  Tuned specifically for the ThinkPad T480s dual-battery layout.
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ── TLP (the workhorse) ──────────────────────────────────────────────────
  services.tlp = {
    enable = true;
    # Charge thresholds (T480s has BAT0 = internal, BAT1 = external/hot-swap)
    settings = with lib; {
      # Stop charging at 80% — extends battery lifespan considerably
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0  = 80;
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1  = 80;

      # CPU performance profile
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Drive power management
      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC  = "254";
      DISK_APM_LEVEL_ON_BAT = "128";

      # Wi-Fi power saving
      WIFI_PWR_ON_AC  = "off";
      WIFI_PWR_ON_BAT = "on";

      # USB autosuspend (keep input devices awake)
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_BTUSB = 1;       # Bluetooth dongle
      USB_BLACKLIST_PHONE = 1;
      USB_BLACKLIST_PRINTER = 1;
      USB_BLACKLIST_WWAN = 1;

      # Audio
      SOUND_POWER_SAVE_ON_AC  = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # PCIe ASPM
      RUNTIME_PM_ON_AC  = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # Bay battery charge behaviour
      NATACPI_ENABLE = 1;

      # Restore threshold after long idle
      RESTORE_THRESHOLDS_ON_BAT = 1;
    };
  };

  # ── thermald — Intel thermal daemon ──────────────────────────────────────
  services.thermald.enable = true;

  # ── power-profiles-daemon (interactive performance profiles) ─────────────
  services.power-profiles-daemon.enable = true;

  # ── upower — user-space power daemon (needed for AGS battery widget) ─────
  services.upower.enable = true;

  # ── logind: lid + power key behaviour ────────────────────────────────────
  services.logind = {
    lidSwitch = "suspend";                  # close lid → suspend
    lidSwitchExternalPower = "suspend";    # with external display → suspend
    lidSwitchDocked = "ignore";             # docked → keep running

    handlePowerKey = "ignore";              # power key → don't act (handled by Hypridle)
    handleSuspendKey = "suspend";
    handleHibernateKey = "hibernate";
    handleLidSwitch = "suspend";

    # Suspend-then-hibernate after 2 hours on battery
    hibernateDelaySec = "2h";

    # Sessions extra settings
    extraConfig = ''
      IdleAction=ignore
      IdleActionSec=0
    '';
  };

  # ── CPU governor — let TLP/PPD own it ────────────────────────────────────
  services.udisks2.enable = true;           # auto-mount USB drives in Thunar

  # ── thermald config tweaks (T480s specific) ─────────────────────────────
  # T480s is well-supported by thermald's "Lenovo IdeaPad" platform profile
  services.thermald.platformProfile = "Lenovo IdeaPad";
}