# =============================================================================
#  terminal.nix — kitty with Matrix palette (fully inline, no .conf files)
# =============================================================================
{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # ── Font ──────────────────────────────────────────────────────────────
      font_family          = "JetBrainsMono Nerd Font";
      bold_font            = "JetBrainsMono Nerd Font Bold";
      italic_font          = "JetBrainsMono Nerd Font Italic";
      bold_italic_font     = "JetBrainsMono Nerd Font Bold Italic";
      font_size            = 12.0;
      line_height          = 1.3;
      adjust_line_height   = 0;
      font_features        = "none";

      # ── Cursor ────────────────────────────────────────────────────────────
      cursor_shape               = "block";
      cursor_beam_thickness      = 1.5;
      cursor_underline_thickness = 2.0;
      cursor_blink_interval      = 0;
      cursor_stop_blinking_after = 2.0;

      # ── Scrollback ────────────────────────────────────────────────────────
      scrollback_lines              = 10000;
      scrollback_pager_history_size = 100;
      scrollback_indicator_opacity  = 0.6;

      # ── Mouse ─────────────────────────────────────────────────────────────
      mouse_hide_wait = 3.0;
      url_color       = "#41cc66";
      url_style       = "curly";
      open_url_with   = "default";
      url_prefixes    = "http https file ftp gemini irc gopher news mailto";

      # ── Performance ───────────────────────────────────────────────────────
      repaint_delay   = 5;
      input_delay     = 3;
      sync_to_monitor = "yes";

      # ── Window layout ─────────────────────────────────────────────────────
      remember_window_size        = "yes";
      initial_window_width        = 1100;
      initial_window_height       = 700;
      window_padding_width        = 12;
      single_window_padding_width = 8;
      window_margin_width         = 0;
      window_resize_step_cells    = 2;
      window_resize_step_lines    = 2;
      window_border_width         = 0;
      draw_minimal_borders        = "no";
      resize_in_steps             = "no";

      # ── Tabs ──────────────────────────────────────────────────────────────
      tab_bar_edge            = "bottom";
      tab_bar_style           = "powerline";
      tab_powerline_style     = "angled";
      tab_title_template      = "{f'{index} — {title}'}";
      active_tab_font_style   = "bold";
      inactive_tab_font_style = "normal";
      tab_bar_background      = "#0d140d";
      tab_bar_margin_color    = "#0d140d";

      # ── Background opacity ────────────────────────────────────────────────
      background_opacity         = 0.92;
      background_blur            = 8;
      dynamic_background_opacity = "yes";

      # ── Bell ──────────────────────────────────────────────────────────────
      enable_audio_bell    = "no";
      visual_bell_duration = 0.05;
      bell_on_tab          = "yes";
      command_on_bell      = "none";

      # ── Misc ──────────────────────────────────────────────────────────────
      allow_hyperlinks      = "yes";
      term                  = "xterm-256color";
      update_check_interval = 0;
      strip_trailing_spaces = "smart";

      # ── Advanced ──────────────────────────────────────────────────────────
      box_drawing_scale       = 0.001;
      wheel_scroll_multiplier = 1.0;

      # ── Colors (was ./theme.conf) ─────────────────────────────────────────
      # Special
      foreground           = "#cfd4cf";
      background           = "#0d140d";
      selection_foreground = "#0d140d";
      selection_background = "#41cc66";
      cursor               = "#41cc66";
      cursor_text_color    = "#0d140d";

      # Black
      color0  = "#1f2a1f";
      color8  = "#2a8a44";

      # Red
      color1  = "#cc4154";
      color9  = "#e2607a";

      # Green (accent / phosphor)
      color2  = "#41cc66";
      color10 = "#5fe07a";

      # Yellow
      color3  = "#d4a05f";
      color11 = "#e6b87a";

      # Blue
      color4  = "#5f8fd4";
      color12 = "#80a8e6";

      # Magenta
      color5  = "#b073d4";
      color13 = "#c899e6";

      # Cyan
      color6  = "#5fd4c8";
      color14 = "#80e6db";

      # White
      color7  = "#cfd4cf";
      color15 = "#e0e6e0";

      # Tab bar
      active_tab_background   = "#161b16";
      active_tab_foreground   = "#41cc66";
      inactive_tab_background = "#0d140d";
      inactive_tab_foreground = "#8a918c";
      tab_bar_background      = "#0d140d";

      # Marks
      mark1_foreground = "#0d140d";
      mark1_background = "#41cc66";
      mark2_foreground = "#0d140d";
      mark2_background = "#5fe07a";
      mark3_foreground = "#0d140d";
      mark3_background = "#2a8a44";
    };

    keybindings = [
      "ctrl+shift+1    > launch --location=vsplit"
      "ctrl+shift+2    > launch --location=hsplit"
      "ctrl+shift+5    > launch --location=split"
      "ctrl+shift+8    > launch --location=osplit"
      "ctrl+shift+enter > launch --cwd=current"
      "ctrl+shift+t    > launch --type=tab"
      "ctrl+shift+q    > close"
      "ctrl+shift+l    > next_layout"
      "ctrl+shift+w    > close"
      "ctrl+tab        > next_window"
      "ctrl+shift+tab  > previous_window"
      "ctrl+alt+1      > move_window_to_screen 1"
      "ctrl+alt+2      > move_window_to_screen 2"
    ];
  };
}
