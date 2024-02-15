{ config, pkgs, inputs, ... }:

{
	home.packages = with pkgs; [
    inputs.gross.packages.${pkgs.system}.gross
		eww-wayland
	];

	# programs.eww = {
	# 	enable = true;
	# 	package = pkgs.eww-wayland;
	# 	configDir = ./eww;
	# };

	xdg.configFile."eww" = {
		source = ./eww;
		recursive = true;
	};

# base00: ---- dark
# base01: ---
# base02: --
# base03: -
# base04: +
# base05: ++
# base06: +++
# base07: ++++ light
# base08: red
# base09: orange
# base0A: yellow
# base0B: green
# base0C: aqua / cyan
# base0D: blue
# base0E: purple
# base0F: brown

	xdg.configFile."eww/css/colors.scss".text = with config.colorScheme.colors; /*scss*/ ''
$base00: #${base00};
$base01: #${base01};
$base02: #${base02};
$base03: #${base03};
$base04: #${base04};
$base05: #${base05};
$base06: #${base06};
$base07: #${base07};
$base08: #${base08};
$base09: #${base09};
$base0A: #${base0A};
$base0B: #${base0B};
$base0C: #${base0C};
$base0D: #${base0D};
$base0E: #${base0E};
$base0F: #${base0F};

$bar-bg: #${base00}33;
$bg: $base02;
$fg: $base07;
	'';
}
