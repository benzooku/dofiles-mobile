# =============================================================================
#  Home Manager — entry point
#  Imports every per-user module under ./home/*.nix
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ── State version — match the NixOS release you build on ─────────────────
  home.stateVersion = "24.11";

  # ── User identity (overridden by NixOS users module if invoked there) ────
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # ── Imports ──────────────────────────────────────────────────────────────
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./gtk.nix
    ./fonts.nix
    ./terminal.nix
    ./wayland-apps.nix
  ];

  # ── XDG user dirs ────────────────────────────────────────────────────────
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
    publicShare = "$HOME/Public";
  };

  # ── XDG mime defaults ────────────────────────────────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"                      = [ "zen-browser.desktop" ];
      "x-scheme-handler/http"          = [ "zen-browser.desktop" ];
      "x-scheme-handler/https"         = [ "zen-browser.desktop" ];
      "application/pdf"                = [ "zathura.desktop" ];
      "image/jpeg"                     = [ "imv.desktop" ];
      "image/png"                      = [ "imv.desktop" ];
      "image/gif"                      = [ "imv.desktop" ];
      "image/webp"                     = [ "imv.desktop" ];
      "video/mp4"                      = [ "mpv.desktop" ];
      "audio/mpeg"                     = [ "mpv.desktop" ];
      "audio/flac"                     = [ "mpv.desktop" ];
      "inode/directory"                = [ "thunar.desktop" ];
      "text/plain"                     = [ "kitty.desktop" ];
    };
  };

  # ── Persistence ──────────────────────────────────────────────────────────
  home.persistence = null;          # no impermanence yet; add if you want it

  # ── Session variables (wayland-friendly) ─────────────────────────────────
  home.sessionVariables = {
    EDITOR            = "nvim";
    VISUAL           = "nvim";
    BROWSER          = "zen-browser";
    TERMINAL         = "kitty";
    TERMINAL_PROGRAM = "kitty";
    PAGER            = "bat";
    MANPAGER         = "bat";
    LESS             = "-FRX";
    # Power-user ENV vars
    NIXPKGS_ALLOW_UNFREE = "1";
    # Wayland
    NIX_XDG_DESKTOP_PORTAL_USE_1_4 = "1";
  };

  # ── Programs without dedicated modules (minimal config) ──────────────────
  programs.zsh.enable = true;       # (also configured in shell.nix)
  programs.bash.enable = true;      # keep bash around for scripts
  programs.ssh.enable = true;
  programs.starship.enable = false; # we configure it manually in shell.nix
}