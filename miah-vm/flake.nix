{
  description = "MiahNix TroubleSome Flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

	# 3rd-party Flake, since Zen is not packaged in the main nixpkgs channel
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    mangowc.url = "github:DreamMaoMao/mangowc";
    nixvim.url = "github:nix-community/nixvim";
    noctalia.url = "github:noctalia-dev/noctalia-shell";

	# include home-manager as an input, and let it 'follow' the main nixpkgs branch
    # letting it install packages from nixpkgs instead of keeping its own repository
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    mangowc,
    noctalia,
    nixvim,
    ...
  } @ inputs: {
  	# same nixos module as before
    nixosConfigurations.miahnix-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        #./hosts/main/sys/configuration.nix
	./configuration.nix
	#./noctalia.nix

	# creating a home-manager module as part of my systems config
	mangowc.nixosModules.mango
	nixvim.nixosModules.nixvim
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

		  # settings for the user hest (that me!)
          # sets which user to configure and where Nix should find the correct files
          #home-manager.users.archgodot = import ./hosts/main/usr/home.nix;
          home-manager.users.archgodot = import ./home.nix;
          home-manager.extraSpecialArgs = {
          
          	# bring in the list of inputs into the home-manager module
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
  };
}
