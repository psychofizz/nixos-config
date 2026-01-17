{
  description = "Unified Flake for saikofisu (System + Home)";

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

    wfetch.url = "github:iynaix/wfetch";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      ### This is the entry point for 'nixos-rebuild switch'
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        # Pass inputs to configuration.nix (if needed)
        specialArgs = { inherit inputs; }; 

        modules = [
          # 1. Your System Configuration (moved from /etc)
          ./configuration.nix

          # 2. Home Manager Module (Connects home.nix to the system)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # This passes 'inputs' to home.nix so you can use wfetch
            home-manager.extraSpecialArgs = { inherit inputs; };

            # This tells Home Manager to read your file
            home-manager.users.saikofisu = import ./home.nix;
          }
        ];
      };
    };
}