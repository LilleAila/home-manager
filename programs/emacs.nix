{ config, pkgs, inputs, lib, ... }:

{
	# https://github.com/nix-community/emacs-overlay
	nixpkgs.overlays = [ ( import inputs.emacs-overlay ) ];
	# home.packages = [
	# ];

	programs.emacs = {
		enable = true;
		# package = pkgs.emacs;
		package = (pkgs.emacsWithPackagesFromUsePackage {
			config = ./emacs/emacs.el;
# TODO: dette virker ikke :(
# Bruke emacs runne ting for org babel tangle i stedet
# og så ta den filen inn i config sånn at
# ting kanskje fungerer
# med sånn ${pkgs.emacs}/bin/emacs --ting fra chatgpt
			# isOrgModeFile = true;
			defaultInitFile = true;
			# package = pkgs.emacs-pgtk; # Wayland-support version, slow
			package = pkgs.emacs;
			alwaysEnsure = true;
			alwaysTangle = true;
		 });
	};
}
