{
  description = "Home Manager configuration of olai";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-colors.url = "github:misterio77/nix-colors";

		# flake-parts = {
		# 	url = "github:hercules-ci/flake-parts";
		# 	inputs.nixpkgs-lib.follows = "nixpkgs";
		# };
		#
		# gross = {
		# 	url = "github:fufexan/gross";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# 	inputs.flake-parts.follows = "flake-parts";
		# };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."olai" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

				extraSpecialArgs = { inherit inputs; };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
