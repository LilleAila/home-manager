{ config, pkgs, inputs, lib, ... }:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix

let
	emacs-package = with pkgs; ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (
		epkgs: [
		]
	));
in
{
	programs.emacs = {
		enable = true;
		package = emacs-package;
	};

	# home.file.".emacs.d/init.el".source = ./init.el;
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
}
