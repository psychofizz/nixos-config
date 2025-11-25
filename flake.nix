{
  description = "Home Manager configuration for saikofisu";

  nixConfig = {
    extra-substituters = [ "https://wfetch.cachix.org" ];
    extra-trusted-public-keys = [ "wfetch.cachix.org-1:lFMD3l0uT/M4+WwqUXpmPAm2kvEH5xFGeIld1av0kus=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wfetch.url = "github:iynaix/wfetch";

    # --- ADDED: Alacritty Theme Input ---
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = { nixpkgs, home-manager, alacritty-theme, ... }@inputs:
    let
      system = "x86_64-linux";

      # --- MODIFIED: Import pkgs with the Overlay ---
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # This makes pkgs.alacritty-theme available in home.nix
        overlays = [ alacritty-theme.overlays.default ];
      };
    in {
      homeConfigurations."saikofisu" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };

        modules = [ ./home.nix ];
      };
    };
}
