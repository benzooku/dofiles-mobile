# =============================================================================
#  Users — defines the "ben" account + wheel / docker / audio groups
# =============================================================================
{ config, pkgs, lib, ... }:

{
  users = {
    users.ben = {
      isNormalUser  = true;
      uid           = 1000;
      home          = "/home/ben";
      shell         = pkgs.zsh;
      description   = "Ben Maurer";
      # Initial password: empty (greetd will set it). Change after first boot.
      initialHashedPassword = "";

      # Memberships
      extraGroups = [
        "wheel"            # sudo
        "networkmanager"   # nm-applet, nmcli
        "docker"           # docker daemon access
        "libvirt"          # virt-manager
        "audio"            # pulse/pipewire access
        "video"            # render nodes
        "input"            # uinput
        "disk"             # mount / disk utilities
        "storage"
        "power"            # power-profiles-daemon, brightnessctl
        "lp"               # printing
        "adbusers"
        "plugdev"
        "i2c"              # for some sensor tools
      ];

      # Open files per process limit (good for browsers / docker)
      openFiles = 4096;
    };

    # greetd user (already defined in greetd.nix but listed here for clarity)
    users.greetd = {
      isSystemUser = true;
      group = "greetd";
      uid = 400;
    };
  };

  users.groups = {
    greetd = { };
  };

  # ── sudo: wheel users don't need a password (set the policy you prefer) ─
  security.sudo = {
    wheelNeedsPassword = false;   # one less prompt; tighten if shared laptop
    execWheelOnly = false;
  };

  # ── Root account disabled (use sudo) ─────────────────────────────────────
  users.mutableUsers = false;

  # ── Auto-login at TTY is OFF — greetd handles the graphical session ──────
  services.getty.autologinUser = null;
}