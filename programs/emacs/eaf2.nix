{ pkgs ? import <nixpkgs> {} }:

let
  # TODO: Package nodejs environment

  pythonEnv = ((pkgs.python311.withPackages(ps: [
    ps.pyqtwebengine
    ps.pyqt5
    ps.qrcode
    ps.qtconsole
    ps.retry
    ps.pymupdf
    # Wrap native dependencies in python env $PATH
    pkgs.aria2
  ])).override { ignoreCollisions = true; });

  node = "${pkgs.nodejs}/bin/node";

  pname = "eaf";
  version = "20210309.0";

in pkgs.melpaBuild {

  inherit pname version;

  src = pkgs.fetchFromGitHub {
		owner = "emacs-eaf";
		repo = "emacs-application-framework";
		rev = "ac135be35220786df1e0bcb4f1a1a95d7c0c7183";
		hash = "sha256-12gVfkWhoc9y4UKfhp2n+iM8nyCetVgviyShm4mhmDA=";
  };

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace eaf.el \
      --replace '"xdotool' '"${pkgs.xdotool}/bin/xdotool' \
      --replace '"wmctrl' '"${pkgs.wmctrl}'
    sed -i s#'defcustom eaf-python-command .*'#'defcustom eaf-python-command "${pythonEnv.interpreter}"'# eaf.el
    substituteInPlace app/terminal/buffer.py --replace \
      '"node"' \
      '"${node}"'
    substituteInPlace app/markdown-previewer/buffer.py --replace \
      '"node"' \
      '"${node}"'
  '';

	buildPhase = ''
	chmod +x install-eaf.py
	./install-eaf.py --ignore-core-deps --ignore-py-deps --ignore-node-deps --install-all-apps
	'';

  installPhase = ''
    rm -r screenshot
    mkdir -p $out/share/emacs/site-lisp/elpa/emacs-$pname-$version
    cp -rv * $out/share/emacs/site-lisp/elpa/emacs-$pname-$version/
  '';

  recipe = pkgs.writeText "recipe" ''
    (eaf
    :repo "emacs-eaf/emacs-application-framework"
    :fetcher github
    :files ("*")
  '';

  packageRequires = with pkgs; [
    ctable
    deferred
    epc
    s
  ];

}
