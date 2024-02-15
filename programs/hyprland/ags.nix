{ config, pkgs, lib, inputs, ... }:

{
	imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
		sass
	];

	programs.ags = {
		enable = true;

		extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
	};

	# Manually managed
	# xdg.configFile."ags" = {
	# 	source = ./ags;
	# 	recursive = true;
	# };

	# Something like this for color scheme
	# xdg.configFile."ags/css/colors.scss".text = with config.colorScheme.colors; /*scss*/ ''
	# '';
}
