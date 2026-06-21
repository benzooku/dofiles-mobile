# =============================================================================
#  greetd + tuigreet — minimal TUI login manager that hands off to Hyprland
# =============================================================================
{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # tuigreet drops the user straight into Hyprland
        command = "tuigreet --cmd Hyprland --asterisks --time --remember --user-menu --theme phosphor";
        user    = "ben";
      };

      # (Optional) additional sessions — defined but not used by default
      initial_session = {
        command = "Hyprland";
        user    = "ben";
      };
    };
  };

  # ── tuigreet itself ──────────────────────────────────────────────────────
  programs.greetd.tuigreet = {
    enable = true;
    settings = {
      theme = [ "phosphor" ];   # built-in green-on-black, fits the Matrix vibe
      time = true;
      asterisks = true;
      remember = true;
      user_menu = true;
      window_padding = "8,8,8,8";
      prompt_border = "rounded";
    };
  };

  # ── greetd needs an nss entry for "greetd" user ─────────────────────────
  users.users.greetd = {
    isSystemUser = true;
    group = "greetd";
    uid = 400;
  };
  users.groups.greetd = { };

  # ── greetd must own the seat it runs on ──────────────────────────────────
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.freedesktop.login1.set-encrypted-password" &&
        subject.local && subject.active && subject.user == "ben"
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}