# =============================================================================
#  wayland-apps.nix — symlink every Wayland dotfile into ~/.config
#  Also registers user-level systemd services (AGS / hypridle / swaync).
# =============================================================================
{ config, pkgs, lib, ... }:

let
  homeDir = config.home.homeDirectory;
  cfgDir  = "${homeDir}/.config";

  # Run after the internal linkGeneration step so all xdg.configFile entries
  # actually exist on disk when our scripts look at them.
  afterLinks = lib.hm.dag.entryAfter [ "linkGeneration" ];
in
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
  };

  # ── Wallpapers dir: declared declaratively so HM owns it ────────────────
  # dataFile with a placeholder ensures the parent dir is created.
  xdg.dataFile."wallpapers/.keep".text = "";

  # ── Activation: ensure ~/.config/nvim points at ~/nixconfig/nvim ───────
  home.activation.nvimSymlink = afterLinks ''
    target="${cfgDir}/nvim"
    link="${homeDir}/nixconfig/nvim"
    mkdir -p "$(dirname "$target")"

    # Stash any pre-existing config once (only first time).
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      if [ ! -e "''${target}.original" ]; then
        mv "$target" "''${target}.original"
      else
        rm -rf "$target"
      fi
    fi

    # Re-link if missing or pointing somewhere else.
    if [ ! -L "$target" ] || [ "$(readlink "$target")" != "$link" ]; then
      ln -sfn "$link" "$target"
    fi
  '';

  # ── Zen browser: place Matrix CSS into every existing chrome profile ───
  home.file.".local/share/zen-template/userChrome.css".source  = ./zen/userChrome.css;
  home.file.".local/share/zen-template/userContent.css".source = ./zen/userContent.css;

  home.activation.zenTemplate = afterLinks ''
    template="${homeDir}/.local/share/zen-template"
    shopt -s nullglob
    for profdir in ${homeDir}/.zen/*/chrome; do
      [ -d "$profdir" ] || continue
      ln -sfn "$template/userChrome.css"  "$profdir/userChrome.css"
      ln -sfn "$template/userContent.css" "$profdir/userContent.css"
    done
  '';

  # ── AGS modules install (bun install at activation) ─────────────────────
  home.activation.agsInstall = afterLinks ''
    agsDir="${cfgDir}/ags"

    if [ ! -f "$agsDir/package.json" ]; then
      echo "AGS: no package.json at $agsDir — skipping."
      exit 0
    fi

    cd "$agsDir"

    # Reinstall if node_modules is missing OR package.json is newer.
    if [ ! -d node_modules ] || [ package.json -nt node_modules ]; then
      echo "AGS: installing dependencies..."
      ${pkgs.bun}/bin/bun install
    else
      echo "AGS: node_modules up to date."
      exit 0
    fi

    # Pick up the new modules in the running AGS service.
    # Skip in --dry-run (HM sets DRY_RUN=1 then).
    if [ -z "''${DRY_RUN:-}" ] && command -v systemctl >/dev/null 2>&1; then
      systemctl --user try-restart ags.service || true
    fi
  '';

  # ── User-level systemd services (HM-style: Unit/Service/Install) ─────────
  systemd.user.services.ags = {
    Unit = {
      Description = "AGS — Matrix status bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ags}/bin/ags run ${cfgDir}/ags";
      Restart = "on-failure";
      RestartSec = "3s";
      Environment = "AGS_CONFIG=${cfgDir}/ags";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hyprland idle manager";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hypridle}/bin/hypridle";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.swaync = {
    Unit = {
      Description = "swaync — Wayland notification daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swaync}/bin/swaync";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}