{
  description = "NixOS and Home Manager configuration for saikofisu";

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
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = { self, nixpkgs, home-manager, alacritty-theme, ... }@inputs:
    let
      system = "x86_64-linux";
      # Define overlays here so we can pass them to the system
      overlays = [ alacritty-theme.overlays.default ];
    in {
    
      ### THE PART YOU WERE MISSING:
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        specialArgs = { inherit inputs; }; 

        modules = [
          # Import your main system config
          ./configuration.nix

          # Apply overlays to the whole system
          { nixpkgs.overlays = overlays; }

          # Import Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Pass inputs to home.nix specifically
            home-manager.extraSpecialArgs = { inherit inputs; };

            # Tell Home Manager to look at home.nix
            home-manager.users.saikofisu = import ./home.nix;
          }
        ];
      };
    };
}
