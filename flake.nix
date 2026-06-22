{
  description = "ThinkPad T480s — Hyprland + Matrix rice (NixOS + Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
    let
      system = "x86_64-linux";

      # Zen Browser isn't in nixpkgs. Pull it from the dedicated flake and
      # expose it as pkgs.zen-browser via an overlay so HM/NixOS modules can
      # just write `pkgs.zen-browser` / `zen-browser` (under `with pkgs;`).
      zenOverlay = final: _prev: {
        zen-browser = zen-browser.packages.${final.stdenv.hostPlatform.system}.default;
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ zenOverlay ];
      };
    in {
      # NixOS system: ThinkPad T480s
      nixosConfigurations.t480s = nixpkgs.lib.nixosSystem {
        inherit system;
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

          # Apply the zen-browser overlay to the NixOS pkgs set so HM
          # (with useGlobalPkgs = true) also sees pkgs.zen-browser.
          { nixpkgs.overlays = [ zenOverlay ]; }
        ];
      };

      # Standalone Home Manager activation (for non-NixOS hosts)
      homeConfigurations."ben@t480s" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/default.nix ];
      };
    };
}