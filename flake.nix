{
  description = "Home Manager configuration for saikofisu";

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
