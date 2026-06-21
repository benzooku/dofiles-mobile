# =============================================================================
#  wayland-apps.nix — symlink every Wayland dotfile into ~/.config
#  Also registers user-level systemd services (AGS / hypridle / swaync).
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ── Symlinks ────────────────────────────────────────────────────────────
  xdg.configFile = {
    # ── Hyprland ─────────────────────────────────────────────────────────
    "hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
    "hypr/hypridle.conf".source = ./hypr/hypridle.conf;

    # ── Walker (CSS only — config handled by ~/.config/walker/) ──────────
    "walker/style.css".source = ./walker/style.css;

    # ── Swaync ───────────────────────────────────────────────────────────
    "swaync/config.json".source = ./swaync/config.json;
    "swaync/style.css".source  = ./swaync/style.css;

    # ── AGS (the v2 source lives here) ──────────────────────────────────
    "ags/package.json".source   = ./ags/package.json;
    "ags/tsconfig.json".source  = ./ags/tsconfig.json;
    "ags/style.scss".source     = ./ags/style.scss;
    "ags/app.tsx".source        = ./ags/app.tsx;
    "ags/widgets/Bar.tsx".source        = ./ags/widgets/Bar.tsx;
    "ags/widgets/Workspaces.tsx".source = ./ags/widgets/Workspaces.tsx;
    "ags/widgets/Clock.tsx".source      = ./ags/widgets/Clock.tsx;
    "ags/widgets/Battery.tsx".source    = ./ags/widgets/Battery.tsx;
    "ags/widgets/Cpu.tsx".source        = ./ags/widgets/Cpu.tsx;
    "ags/widgets/Network.tsx".source    = ./ags/widgets/Network.tsx;
    "ags/widgets/Audio.tsx".source      = ./ags/widgets/Audio.tsx;
    "ags/widgets/Tray.tsx".source       = ./ags/widgets/Tray.tsx;
    "ags/widgets/Media.tsx".source      = ./ags/widgets/Media.tsx;

    # ── Waybar (backup, currently inactive) ──────────────────────────────
    "waybar/config.jsonc".source = ./waybar/config.jsonc;
    "waybar/style.css".source    = ./waybar/style.css;

    # ── Zen Browser Matrix theme ─────────────────────────────────────────
    "zen/userChrome.css".source   = ./zen/userChrome.css;
    "zen/userContent.css".source  = ./zen/userContent.css;

    # ── Misc CLI app configs ─────────────────────────────────────────────
    "starship/starship.toml".source = ./starship/starship.toml;
    "btop/btop.conf".source        = ./btop/btop.conf;
    "fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
    "cava/config".source           = ./cava/config;

    # ── nvim symlink ─────────────────────────────────────────────────────
    # ~/.config/nvim → <flake-dir>/nvim/
    # We do this via a tiny wrapper script in home.activation (below) so we
    # don't recursively mirror the user's existing config.
  };

  # ── Activation: ensure ~/.config/nvim points at ~/nixconfig/nvim ───────
  home.activation.nvimSymlink = {
    text = ''
      if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        # Existing dir or file: rename it aside (one-time only)
        if [ ! -e "$HOME/.config/nvim.original" ]; then
          mv "$HOME/.config/nvim" "$HOME/.config/nvim.original"
        else
          rm -rf "$HOME/.config/nvim"
        fi
      fi
      mkdir -p "$HOME/.config"
      if [ ! -L "$HOME/.config/nvim" ]; then
        ln -s "$HOME/nixconfig/nvim" "$HOME/.config/nvim"
      fi
    '';
  };

  # ── Activation: ensure the wallpaper directory exists ───────────────────
  home.activation.wallpaperDir = {
    text = ''
      mkdir -p "$HOME/.local/share/wallpapers"
    '';
  };

  # ── Zen browser: place Matrix CSS into the right chrome dir ─────────────
  # Zen reads userChrome from
  #   ~/.zen/<profile>/chrome/userChrome.css
  # We can't know the profile name ahead of time, so we drop the files into
  # a config dir and use a tiny init script (below).
  home.file.".local/share/zen-template/userChrome.css".source = ./zen/userChrome.css;
  home.file.".local/share/zen-template/userContent.css".source = ./zen/userContent.css;

  home.activation.zenTemplate = {
    text = ''
      # Symlink Zen chrome CSS into every existing Zen profile, and create
      # a template directory the user can copy manually for new profiles.
      for profdir in "$HOME"/.zen/*/chrome; do
        [ -d "$profdir" ] || continue
        if [ ! -L "$profdir/userChrome.css" ] && [ ! -e "$profdir/userChrome.css" ]; then
          ln -s "$HOME/.local/share/zen-template/userChrome.css" "$profdir/userChrome.css"
        fi
        if [ ! -L "$profdir/userContent.css" ] && [ ! -e "$profdir/userContent.css" ]; then
          ln -s "$HOME/.local/share/zen-template/userContent.css" "$profdir/userContent.css"
        fi
      done
    '';
  };

  # ── User-level systemd services ─────────────────────────────────────────
  # AGS — autostarted when Hyprland starts (via hyprland.conf exec-once)
  systemd.user.services.ags = {
    description = "AGS — Matrix status bar";
    wantedBy = [ "graphical-session.target" ];
    partOf    = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ags}/bin/ags run /home/ben/.config/ags";
      Restart = "on-failure";
      RestartSec = 3;
    };

    environment = {
      AGS_CONFIG = "/home/ben/.config/ags";
    };
  };

  # ── hypridle (replaces default, runs as user) ───────────────────────────
  systemd.user.services.hypridle = {
    description = "Hyprland idle manager";
    wantedBy = [ "graphical-session.target" ];
    partOf    = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hypridle}/bin/hypridle";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # ── swaync (notification daemon) ────────────────────────────────────────
  systemd.user.services.swaync = {
    description = "swaync — Wayland notification daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf    = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swaync}/bin/swaync";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # ── AGS modules install (npm ci at activation) ─────────────────────────
  home.activation.agsInstall = {
    text = ''
      if [ -f "$HOME/.config/ags/package.json" ]; then
        cd "$HOME/.config/ags"
        if [ ! -d node_modules ]; then
          # use Home Manager's bundler if available, else fallback to system
          if command -v bun >/dev/null 2>&1; then
            bun install
          elif command -v npm >/dev/null 2>&1; then
            npm install
          fi
        fi
      fi
    '';
  };
}