# =============================================================================
#  terminal.nix — kitty with Matrix palette
# =============================================================================
{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    # Use the generated config under ./kitty/kitty.conf
    settingsFile = ./kitty/kitty.conf;
  };
}