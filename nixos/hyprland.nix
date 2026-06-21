# =============================================================================
#  Hyprland — Wayland compositor + xdg-desktop-portal + audio + polkit
# =============================================================================
{ config, pkgs, lib, ags, hyprland, ... }:

let
  # AGS v2.3.0 — built from the flake input
  agsPkg = ags.packages.${pkgs.system}.default;
in
{
  # ── Hyprland ─────────────────────────────────────────────────────────────
  # Built from the pinned hyprland flake input (latest git)
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
  };

  # ── xdg-desktop-portal (Hyprland backend) ───────────────────────────────
  xdg = {
    portal = {
      enable = true;
      packages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome   # for legacy GTK portals (file chooser)
      ];
      config.hyprland.default = [ "*" ];
      config.common.default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };

  # ── PipeWire + WirePlumber ───────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };
  services.wireplumber.enable = true;

  # ── Polkit (for GUI auth prompts like GParted, dock, etc.) ───────────────
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  # ── Session-wide environment for Hyprland ────────────────────────────────
  environment.sessionVariables = {
    # Qt/Wayland niceties
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # XWayland
    GDK_BACKEND = "wayland,x11";
    # Firefox/Wayland
    MOZ_ENABLE_WAYLAND = "1";
    # Cursor
    XCURSOR_THEME = "Bibata-Modern-Dark";
    XCURSOR_SIZE = "24";
    # Java HiDPI
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Cursor on Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # swww daemon is launched by hyprland.conf (exec-once)
    # AGS reads config from ~/.config/ags (symlinked by Home Manager)
    AGS_CONFIG = "/home/ben/.config/ags";
  };

  # ── Make sure XDG_RUNTIME_DIR exists for user sessions ───────────────────
  environment.etc."pam.d/hyprland".text = ''
    # PAM config used by greetd → Hyprland
  '';

  # ── Programs useful in any Hyprland session ──────────────────────────────
  programs = {
    dconf.enable = true;
    gnome-keyring.enable = true;       # auto-unlock for SSH/git
    zsh.enable = true;                 # default shell (also set in users.nix)
  };

  # ── System pkgs that don't fit into Home Manager (need root) ────────────
  environment.systemPackages = with pkgs; [
    # Required for greetd → Hyprland session
    cage                        # fallback if Hyprland crashes
    xwayland
    wayland-utils
    wlr-randr
    # Screenshot
    grim slurp satty
    # Wallpaper engine
    swww
    # Misc
    polkit polkit_gnome
    brightnessctl
    playerctl
    pavucontrol
    qt6Packages.qtwayland
    gvfs
    # AGS runtime (pulled from the flake input)
    agsPkg
  ];

  # ── Programs needed for Hyprland to start cleanly ────────────────────────
  services.xserver.enable = false;     # we're pure Wayland, no X server
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
}