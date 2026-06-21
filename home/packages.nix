# =============================================================================
#  packages.nix — every user-level CLI/GUI app the rice needs
# =============================================================================
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── Terminal + shell helpers ─────────────────────────────────────────
    kitty
    tmux
    zoxide
    fzf
    eza
    bat
    ripgrep
    fd
    jq
    yq-go
    direnv
    nix-direnv
    starship

    # ── System info / monitoring ─────────────────────────────────────────
    btop
    fastfetch
    lm_sensors
    acpi
    sysstat
    upower
    pciutils
    usbutils

    # ── File managers + viewers ──────────────────────────────────────────
    yazi                       # TUI
    thunar thunar-archive-plugin thunar-volman
    imv                        # image viewer
    zathura zathura-pdf-mupdf  # PDF
    sxiv                       # fallback image viewer

    # ── Media ─────────────────────────────────────────────────────────────
    mpv
    cava                       # audio visualizer
    pavucontrol
    pamixer
    playerctl

    # ── Audio + wallpaper ────────────────────────────────────────────────
    swww
    swaync
    walker                     # GTK4 launcher
    hyprlock
    hypridle
    grim slurp satty           # screenshots

    # ── Editor + browser + email ─────────────────────────────────────────
    nvim
    zen-browser
    thunderbird

    # ── Git + helpers ────────────────────────────────────────────────────
    lazygit
    git
    gh
    delta                      # better git diff
    pre-commit

    # ── Containerisation ─────────────────────────────────────────────────
    docker
    docker-compose
    dive                       # docker image explorer
    lazydocker                 # TUI docker manager

    # ── Dev toolchains ───────────────────────────────────────────────────
    gcc
    clang
    lldb
    gnumake
    cmake
    pkg-config
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs_22
    rustc
    cargo
    rustup
    go
    jdk21
    elixir
    erlang
    # Hex / rebar for Elixir (Erlang/OTP tooling)
    rebar3
    hex

    # ── Fonts (the user might add their own later) ───────────────────────
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # ── GTK / Qt theme deps ──────────────────────────────────────────────
    adw-gtk3
    gnome-themes-extra
    papirus-icon-theme
    bibata-cursors

    # ── Misc utilities ───────────────────────────────────────────────────
    networkmanager
    network-manager-applet
    blueman
    pavucontrol
    brightnessctl
    wl-clipboard                # wl-copy / wl-paste
    clipman                     # clipboard manager
    xdg-utils
    xdg-user-dirs
    polkit_gnome
    polkit
    wlogout                     # power menu (SUPER+SHIFT+E)
    wlopm                       # wayland output power manager
    appimage-run
    glib
    gtk3
    gtk4
    libadwaita

    # ── Password manager (web — included in Walker apps list) ────────────
    # nothing to install — Proton Pass is web-only. Listed here for visibility:
    #   proton-pass: web app — open via walker or shell command:
    #   xdg-open "https://pass.proton.me"
  ];
}