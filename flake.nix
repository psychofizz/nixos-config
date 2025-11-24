{
  description = "Home Manager configuration for saikofisu";

  # 1. Add the Binary Cache so you don't have to compile from source
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

    # Google's new vibeDE
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 2. Add wfetch input
    wfetch.url = "github:iynaix/wfetch";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."saikofisu" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # This passes the 'inputs' variable to your home.nix
        extraSpecialArgs = { inherit inputs; };

        # Point to your existing configuration file
        modules = [ ./home.nix ];
      };
    };
}
