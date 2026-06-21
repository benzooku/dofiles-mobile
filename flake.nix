{
  description = "ThinkPad T480s — Hyprland + Matrix rice (NixOS + Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ags, nixpkgs-wayland, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # ── NixOS system: ThinkPad T480s ─────────────────────────────────────
      nixosConfigurations.t480s = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit ags hyprland; };
        modules = [
          ./nixos/configuration.nix

          # Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ben = import ./home/default.nix;
              # Managed by users.nix
              home-manager.users.ben.home.stateVersion = "24.11";
            };
          }
        ];
      };

      # ── Standalone Home Manager activation (for non-NixOS hosts) ─────────
      homeConfigurations."ben@t480s" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/default.nix ];
      };
    };
}