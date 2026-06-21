# =============================================================================
#  gtk.nix — GTK3 / GTK4 / libadwaita Matrix overrides
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ── dconf ────────────────────────────────────────────────────────────────
  dconf = {
    enable = true;

    # libadwaita accent color (phosphor green)
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme    = "adw-gtk3-dark";
        icon-theme   = "Papirus-Dark";
        cursor-theme = "Bibata-Modern-Dark";
        cursor-size  = 24;
        font-name    = "JetBrains Mono NF 11";
        monospace-font-name = "JetBrains Mono NF 11";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
    };
  };

  # ── GTK3 settings ────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Dark";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "JetBrains Mono NF";
      size = 11;
    };
    extraConfig = {
      Settings = {
        gtk-application-prefer-dark-theme = 1;
        gtk-theme-name = "adw-gtk3-dark";
        gtk-icon-theme-name = "Papirus-Dark";
        gtk-cursor-theme-name = "Bibata-Modern-Dark";
        gtk-cursor-theme-size = 24;
        gtk-font-name = "JetBrains Mono NF 11";
        gtk-modules = "colorreload-gtk-module";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-enable-animations = true;
      };
    };
  };

  # ── Configs ──────────────────────────────────────────────────────────────
  xdg.configFile = {
    "gtk-3.0/settings.ini".source = ./gtk-3.0/settings.ini;
    "gtk-4.0/settings.ini".source = ./gtk-4.0/settings.ini;
    "gtk-4.0/gtk.css".source     = ./gtk-4.0/gtk.css;
  };
}