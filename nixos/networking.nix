# =============================================================================
#  Networking — NetworkManager + firewall + resolved
# =============================================================================
{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "t480s";
    domain   = "localdomain";

    # NetworkManager handles everything (Wi-Fi, Ethernet, VPN, USB tether)
    networkmanager = {
      enable = true;
      wifi = {
        scanOnLowSignal = true;
        backend = "iwd";   # iwd is faster + more power-efficient than wpa_supplicant
      };
      # Random MAC per-connection (slight privacy boost on Wi-Fi)
      wifi.macAddress = "random";
    };

    # systemd-resolved for proper DNS over NetworkManager
    useDHCP = true;

    # Firewall — only SSH would be opened (we don't run sshd by default)
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      # Don't block mDNS
      allowPing = true;
      logRefusedConnections = false;
    };

    # IPv6 enabled by default
    enableIPv6 = true;

    # Disable ConnMan / dhcpcd — NetworkManager covers it
    dhcpcd.enable = false;
  };

  # systemd-resolved (symlink /etc/resolv.conf → /run/systemd/resolve/stub-resolv.conf)
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ "1.1.1.1" "9.9.9.9" ];
  };

  # NTP
  services.timesynced = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
  };
}