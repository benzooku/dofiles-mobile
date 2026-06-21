# =============================================================================
#  nix-settings — flakes, auto-GC, store auto-optimise
# =============================================================================
{ config, pkgs, lib, ... }:

{
  nix = {
    # Enable flakes + the new `nix` CLI
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      # Auto-optimise store contents (hard-link duplicates → save disk)
      auto-optimise-store = true;

      # Allow unfree in flake evaluation (mirror nixpkgs.config.allowUnfree)
      allow-unfree = true;

      # Keep build logs around for a week
      keep-derivations = "7d";
      keep-outputs     = "7d";

      # Substituters + trusted keys
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7gGq3M7B2KlxkOF4SJMpY4HH6MBeRmOj+wJ9XCMwlI="
      ];

      # Connect substitution (parallel downloads)
      connect-timeout = 5;
      max-jobs = "auto";
    };

    # Garbage collect anything older than 30 days, weekly
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };

    # Auto-store-optimise runs weekly (separate from GC)
    optimise = {
      automatic = true;
      dates     = [ "weekly" ];
    };
  };

  # ── Use the new modular nix store settings (for Nix 2.20+) ───────────────
  nix.settings.auto-allocate-uids = true;
  nix.settings.allowed-uris       = [ ];
}