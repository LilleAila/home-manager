{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
	name = "emacs-application-framework";

	src = pkgs.fetchFromGitHub {
		owner = "emacs-eaf";
		repo = "emacs-application-framework";
		rev = "ac135be35220786df1e0bcb4f1a1a95d7c0c7183";
		hash = "sha256-12gVfkWhoc9y4UKfhp2n+iM8nyCetVgviyShm4mhmDA=";
	};

	buildInputs = with pkgs; [
		# nodePackages.album-art
		libinput
		libevdev
		wmctrl
		xdotool
		pkg-config
	];

	buildPhase = ''
	chmod +x install-eaf.py
	${pkgs.python311}/bin/python3 install-eaf.py --ignore-core-deps --ignore-sys-deps --ignore-py-deps --ignore-node-deps --install-all-apps
	'';

  installPhase = ''
	mkdir -p $out/share/emacs/site-lisp/elpa/emacs-application-framework
	cp -rv * $out/share/emacs/site-lisp/elpa/emacs-application-framework/
  '';
}
