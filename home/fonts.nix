# =============================================================================
#  fonts.nix — fontconfig, JetBrainsMono NF as default everywhere
# =============================================================================
{ config, pkgs, lib, ... }:

{
  fonts = {
    enableDefaultFonts = true;

    packages = with pkgs; [
      # The required one — used everywhere
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      # Nice-to-haves
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      liberation_ttf
      dejavu_fonts
      fira-code
      fira-code-symbols

      # Extra monospace fallbacks
      iosevka
      jetbrains-mono
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif      = [ "JetBrainsMono Nerd Font" ];
        sansSerif  = [ "JetBrainsMono Nerd Font" ];
        monospace  = [ "JetBrainsMono Nerd Font" ];
        emoji      = [ "Noto Color Emoji" ];
      };

      # Sub-pixel rendering on HiDPI displays
      subpixel = {
        enable = true;
        rgb = true;
      };

      # Disable bitmap scaling (looks bad on HiDPI)
      useBitmaps = false;

      # Slight hinting
      hinting = {
        enable = true;
        style = "slight";
      };
    };
  };

  # ── Older fontconfig path (some apps still check here) ───────────────────
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>monospace</family>
        <prefer>
          <family>JetBrainsMono Nerd Font</family>
          <family>JetBrains Mono NF</family>
        </prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>JetBrainsMono Nerd Font</family>
        </prefer>
      </alias>
      <alias>
        <family>serif</family>
        <prefer>
          <family>JetBrainsMono Nerd Font</family>
        </prefer>
      </alias>
    </fontconfig>
  '';
}