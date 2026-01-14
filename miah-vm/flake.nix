{
  description = "MiahNix TroubleSome Flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self,nixpkgs,home-manager,zen-browser,mangowc,noctalia,nixvim, ... } @ inputs: {
    nixosConfigurations.miahnix-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
	      ./configuration.nix
      	nixvim.nixosModules.nixvim
      	mangowc.nixosModules.mango
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.archgodot = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
            };
          };
        }
      ];
    };
  };
}
