{ config, pkgs, inputs, lib, ... }:

# let
# 	gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };
# in

{	
	home = {
		username = "olai";
		homeDirectory = "/home/olai";
		stateVersion = "23.11"; # Changed from stable 23.05
	};

	# targets.genericLinux.enable = true; # ENABLE ON NON-NIXOS

  imports = [
		inputs.nix-colors.homeManagerModules.default
    ./programs/shell/zsh.nix
    ./programs/shell/neovim.nix
	  ./programs/shell/terminal.nix
		./programs/shell/lf.nix

		./programs/browser.nix
		# ./programs/discord.nix

		./programs/wallpaper/wallpaper.nix
	  ./programs/hyprland/hyprland.nix
  ];

	# https://github.com/tinted-theming/base16-schemes/
	# colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
	colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

	# nixpkgs.config.allowUnfree = true;
	# nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	# 	"steam" # does not work idk
	# ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
		gcc
		cmake

		ripgrep
		fd

		nodejs_20
		python311

		neofetch
		dconf

		webcord-vencord

		# steam # Install steam in system config instead
		protonup-qt
		pavucontrol

		( pkgs.writeShellScriptBin "hm-rebuild" /*bash*/ ''
		${pkgs.home-manager}/bin/home-manager switch
		# ${pkgs.swww}/bin/swww img ~/Wallpapers/hyprland_wallpaper.png
		${pkgs.hyprland}/bin/hyprctl reload
		pkill waybar
		${pkgs.waybar}/bin/waybar &
		'' )

		# ( pkgs.writeShellScriptBin "kittybg" /*bash*/ ''
		# ${pkgs.kitty}/bin/kitty -c "${pkgs.writeText "kittyconfigbg.conf" ''
		# 	background_opacity 0.0
		# '' }" --class="kitty-bg" ${pkgs.writeShellScriptBin "start" /*bash*/''
		# 	sleep 1 && ${pkgs.cava}/bin/cava -p ${pkgs.writeText "cavaconf" ''
		# 		[general]
		# 		sensitivity = 25
		#
		# 		[color]
		# 		foreground = "#${config.colorScheme.colors.base05}"
		# 	''}
		# ''}/bin/start
		# '' )
  ];

	programs.git = {
		enable = true;
		userName = "LilleAila";
		userEmail = "olai.solsvik@gmail.com";
		aliases = {
			pu = "push";
			co = "checkout";
			cm = "commit";
		};
		extraConfig = {
			credential.helper = "store"; # I should probably switch to ssh
		};
	};

  programs.home-manager.enable = true;
}
