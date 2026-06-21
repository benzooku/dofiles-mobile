# NixOS Flake — ThinkPad T480s · Hyprland · Matrix Rice

A fully declarative NixOS configuration for a **ThinkPad T480s** with Hyprland,
a Matrix-themed AGS bar, and a complete dev environment. Home Manager is wired
in as a NixOS module so the whole system activates with one command.

> Channel: **`nixos-unstable`** · User: `ben` · Hostname: `t480s`

---

## ✨ What you get

- **Hyprland** (Wayland compositor) with a Matrix color palette
- **AGS v2.3.0** status bar (with **Waybar** as a commented-out fallback)
- **Walker** (GTK4 launcher), **swaync** notifications, **hyprlock** + **hypridle**
- **kitty** terminal, **zsh + starship + zoxide + fzf**, **tmux**
- **swww** wallpaper engine, **zen-browser** with Matrix theme overrides
- GTK3/4 themed with `adw-gtk3-dark` + libadwaita + custom CSS
- Full dev toolchain: Python, Node, Rust, Go, Elixir/Erlang, JDK, C/C++
- **Docker + docker-compose**, **lazygit**, **lazygit**, modern CLI replacements
- Power management tuned for the T480s (TLP, thermald, charge thresholds 75/80)

---

## 📦 Layout

```
nixconfig/
├── flake.nix                ← entry point
├── nixos/                   ← system-level modules (NixOS)
├── home/                    ← user-level modules (Home Manager)
├── nvim/                    ← your existing nvim config goes here
└── README.md
```

See `flake.nix` for the full input/output structure.

---

## 🚀 First-time install (clean system)

```bash
# 1. Install NixOS minimal ISO, mount, etc. then chroot in.

# 2. Generate the hardware config from your running kernel:
sudo nixos-generate-config --root /mnt
# This creates /mnt/etc/nixos/hardware-configuration.nix

# 3. Drop the hardware config into this flake:
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
        ~/nixconfig/nixos/hardware-configuration.nix

# 4. Drop your existing nvim config into:
#    ~/nixconfig/nvim/

# 5. Drop a wallpaper at:
#    ~/.local/share/wallpapers/matrix-crt.png

# 6. Build & switch:
sudo nixos-rebuild switch --flake ~/nixconfig#t480s
```

After the first successful build, drop the wallpaper image and nvim config
and rebuild again.

---

## 🔁 Day-to-day rebuilds

```bash
sudo nixos-rebuild switch --flake ~/nixconfig#t480s
# or, for a dry-run:
sudo nixos-rebuild build --flake ~/nixconfig#t480s
# or, to update:
cd ~/nixconfig && nix flake update
```

---

## 🎨 Color palette (Matrix, medium intensity)

| Role         | Hex       |
| ------------ | --------- |
| bg           | `#0d140d` |
| surface      | `#161b16` |
| surface-hi   | `#1d271d` |
| border       | `#1f2a1f` |
| text         | `#cfd4cf` |
| text-dim     | `#8a918c` |
| accent       | `#41cc66` |
| accent-bri.  | `#5fe07a` |
| accent-dim   | `#2a8a44` |
| error        | `#cc4154` |
| warning      | `#d4a05f` |

---

## ⚠️  TODOs (placeholders you need to fill)

1. **`nixos/hardware-configuration.nix`** — regenerate via `nixos-generate-config`
   on the target machine. The current file is a stub.
2. **`nvim/`** — drop your existing Neovim config here (Home Manager symlinks
   `~/.config/nvim` → `<flake-dir>/nvim/`).
3. **`~/.local/share/wallpapers/matrix-crt.png`** — your wallpaper. The path is
   referenced by `swww` and `hyprlock`.
4. **Git identity** — `home/git.nix` has a placeholder; tweak to taste.
5. **Secrets** — none committed. Use `git-crypt`, `sops-nix`, or `agenix` if
   you need them.

---

## 🛟 Fallbacks

- **AGS dies?** Edit `home/wayland-apps.nix` and uncomment the Waybar systemd
  service, comment out the AGS one. Rebuild.
- **Wayland breaks?** Boot into a TTY, edit `nixos/greetd.nix` to use
  `cage`/`foot`, or remove greetd entirely and rely on auto-login to TTY +
  `startx`.