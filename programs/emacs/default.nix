{ config, pkgs, inputs, lib, ... }:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix

let
	emacs-package = with pkgs; ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (
		epkgs: [
			epkgs.use-package
			epkgs.doom-themes

			epkgs.ivy
			epkgs.ivy-rich
			epkgs.counsel
			epkgs.swiper
			epkgs.helpful

			epkgs.all-the-icons
			epkgs.doom-modeline

			epkgs.undo-tree

			epkgs.evil
			epkgs.evil-collection

			epkgs.which-key
			epkgs.general
			epkgs.hydra
		]
	));
in
{
	programs.emacs = {
		enable = true;
		package = emacs-package;
		# ==========
		# Works if all code is in a single file
		# I just declare manually because i get more control
		# ==========
		# package = (pkgs.emacsWithPackagesFromUsePackage {
		# 	config = ./init.el;
		# 	defaultInitFile = true;
		# 	package = pkgs.emacs;
		# 	alwaysEnsure = true;
		# 	# alwaysTangle = true;
		# 	# extraEmacsPackages = epkgs: [
		# 	# 	epkgs.doom-themes
		# 	# ];
		# });
	};

	home.file.".emacs.d" = {
		source = lib.cleanSourceWith {
			filter = name: _type: let
				baseName = baseNameOf (toString name);
			in
				!(lib.hasSuffix ".nix" baseName);
			src = lib.cleanSource ./.;
		};
		recursive = true;
	};

	# Restart with systemctl --user restart emacs
	services.emacs = {
		enable = true;
		package = emacs-package;
		client.enable = true;
	};
}
