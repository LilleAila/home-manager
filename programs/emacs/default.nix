{ config, pkgs, inputs, lib, ... }:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix

let
	emacs-package = with pkgs; ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (
		epkgs: [
			# === Use-package ===
			epkgs.use-package

			# === Completion ===
			epkgs.ivy
			epkgs.ivy-rich
			epkgs.counsel
			epkgs.swiper
			epkgs.helpful

			# === UI ===
			epkgs.doom-themes
			epkgs.all-the-icons
			epkgs.doom-modeline

			# === Keybinds ===
			epkgs.evil
			epkgs.evil-collection
			epkgs.which-key
			epkgs.general
			epkgs.hydra

			# === IDE ===
			epkgs.lsp-mode
			epkgs.lsp-ui
			epkgs.lsp-treemacs
			epkgs.lsp-ivy
			epkgs.company
			epkgs.company-box
			epkgs.undo-tree
			epkgs.typescript-mode
		]
	));
in
{
	home.packages = with pkgs; [
		# # === EAF ===
		# xdotool
		# jq
		# wmctrl
		# aria
		# fd
		# python311
		# python311Packages.pyqt6-webengine
		# python311Packages.pyqt6-sip
		# python311Packages.pyqt6
		# python311Packages.lxml
		# python311Packages.requests
		# python311Packages.pandas
		# python311Packages.epc
		# python311Packages.sexpdata
		# python311Packages.tld
		# python311Packages.qrcode # eaf-file-browser
		# python311Packages.pysocks # eaf-browser
		# python311Packages.pymupdf # eaf-pdf-viewer
		# python311Packages.pypinyin # eaf-file-manager
		# python311Packages.psutil # eaf-system-monitor
		# python311Packages.retry # eaf-markdown-previewer
		# python311Packages.markdown

		# === TypeScript ===
		nodejs
		nodePackages.npm
		nodePackages.typescript
		nodePackages.typescript-language-server
	];

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
