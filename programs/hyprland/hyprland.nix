{ config, pkgs, lib, inputs, ... }:

let
	startupScript = pkgs.pkgs.writeShellScriptBin "start" /* bash */ ''
		${inputs.hyprland.packages."${pkgs.system}".hyprland}/bin/hyprctl setcursor "Bibata-Modern-Ice" 24 &
		${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
		${pkgs.waybar}/bin/waybar &
		${pkgs.mako}/bin/mako &
		# ${pkgs.swww}/bin/swww init &
		sleep 1
		# ${pkgs.swww} img ~/Wallpapers/hyprland_wallpaper.png --transition-type none &
	'';
in

{
  home.packages = with pkgs; [
	  seatd
		# wezterm
		# kitty
		# wofi
		rofi-wayland
		dolphin
		# firefox
		qutebrowser

		libnotify
		swww
		networkmanagerapplet
		grim
		slurp
		wl-clipboard
		swappy
		
		avizo
		pamixer
		# pactl
		playerctl
		brightnessctl

		grimblast
	];

	imports = [
		./waybar.nix
		./wlogout.nix
		# ./eww.nix
	];

	# programs.eww = {
	# 	enable = true;
	# 	package = pkgs.eww-wayland;
	# 	configDir = ./eww;
	# };

	# services.dunst = {
	# 	enable = true;
	# 	package = pkgs.dunst;
	# };

	services.mako = {
		enable = true;
		backgroundColor = "#${config.colorScheme.colors.base01}";
		borderColor = "#${config.colorScheme.colors.base0E}";
		borderRadius = 5;
		borderSize = 2;
		textColor = "#${config.colorScheme.colors.base04}";
		layer = "overlay";
	};

	programs.swaylock = {
		enable = true;
		package = pkgs.swaylock-effects;
		settings = {
			screenshot = true;
			clock = true;
			indicator-radius = 100;
			indicator-thickness = 7;
			effect-blur = "7x5";
			effect-vignette = "0.5:0.5";
			ring-color = "${config.colorScheme.colors.base06}";
			key-hl-color = "${config.colorScheme.colors.base0B}";
			line-color = "00000000";
			inside-color = "${config.colorScheme.colors.base00}88";
			separator-color = "00000000";
			grace = 2;
			fade-in = 0.2;
		};
	};

	services.avizo = {
		enable = true;
		package = pkgs.avizo;
		settings.default = {
			time = 1.0;
			width = 160;
			height = 160;
			padding = 12;
			y-offset = 0.9;
			border-radius = 16;
			border-width = 3;
			block-height = 10;
			block-spacing = 2;
			block-count = 10;
			fade-in = 0.2;
			fade-out = 0.2;
			background = "#${config.colorScheme.colors.base03}";
			bar-bg-color = "#${config.colorScheme.colors.base02}";
			border-color = "#${config.colorScheme.colors.base05}";
			bar-fg-color = "#${config.colorScheme.colors.base05}";
		};
	};

	qt = {
		enable = true;
		platformTheme = "gtk";
		style.name = "adwaita-dark";
		style.package = pkgs.adwaita-qt;
	};

	gtk = {
		enable = true;
		cursorTheme.package = pkgs.bibata-cursors;
		cursorTheme.name = "Bibata-Modern-Ice";
		theme.package = pkgs.adw-gtk3;
		theme.name = "adw-gtk3-dark";
		iconTheme.package = pkgs.papirus-icon-theme;
		iconTheme.name = "Papirus-Dark";
	};

	# # Instead put it in the home folder, for example to have multiple at once without rebuilding
	# home.file = {
	# 	".icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
	# };
	# gtk-cursorTheme.name = "Bibata-Modern-Ice"

	xdg.mimeApps.defaultApplications = {
		"text/plain" = [ "neovide.desktop" ];
		"application/pdf" = [ "zathura.desktop" ];
		"image/*" = [ "sxiv.desktop" ];
		"video/png" = [ "mpv.desktop" ];
		"video/jpg" = [ "mpv.desktop" ];
		"video/*" = [ "mpv.desktop" ];
	};


	home.file.".config/swappy/config".text = ''
	[Default]
	save_dir=$HOME/Screenshots/Edited
	save_filename_format=%Y-%m-%d,%H:%M:%S.png
	show_panel=true
	# early_exit=true
	'';

	wayland.windowManager.hyprland = {
		enable = true;
		package = inputs.hyprland.packages."${pkgs.system}".hyprland;
		# enableNvidiaPatches = true;
		systemd.enable = true;
		xwayland.enable = true;

		# plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
		# 	# borders-plus-plus
		# 	# hyprwinwrap
		# 	hyprbars
		# ];
		#
		# settings = {
		# 	plugin = {
		# 		hyprbars = {
		# 			bar_height = 20;
		# 			hyprbars-button = [
		# 				"rgb(ff4040), 10, , hyprctl dispatch killactive"
		# 				"rgb(eeee11), 10, , hyprctl dispatch killactive"
		# 			];
		# 		};
		# 	};
		# };

		settings = {
			monitor = "eDP-1,preferred,auto,1";
			exec-once = ''${startupScript}/bin/start'';
			env = [
				"XCURSOR_SIZE,24"
				"GRIMBLAST_EDITOR,\"swappy -f\""
			];

			"$terminal" = "kitty";
			"$fileManager" = "dolphin";
			"$webBrowser" = "firefox";
			"$launcher" = "rofi -show drun -show-icons";
			"$mainMod" = "SUPER";
			# "$screenshot_format" = "%Y-%m-%d,%H:%M:%S.png";
			"$screenshot_args" = "--notify --freeze ~/Screenshots/Raw/$(date +\"%Y-%m-%d,%H:%M:%S.png\")";
			bind = [
				"$mainMod SHIFT, E, exec, wl-paste | swappy -f -"
				"$mainMod, S, exec, grimblast copysave area $screenshot_args"
				"$mainMod SHIFT, S, exec, grimblast copysave active $screenshot_args"
				", PRINT, exec, grimblast copysave output $screenshot_args"
				"SHIFT, PRINT, exec, grimblast copysave screen $screenshot_args"

				# Apps
				"$mainMod, return, exec, $terminal"
				"$mainMod, space, exec, $launcher"
				"$mainMod, E, exec, $fileManager"
				"$mainMod, B, exec, $webBrowser"

				# WM commands
				", XF86PowerOff, exec, pgrep -x wlogout && pkill -x wlogout || wlogout"
				"$mainMod, W, killactive,"
				"$mainMod, O, fullscreen, 0"
				"$mainMod SHIFT, O, fullscreen, 1"
				"$mainMod, F, togglefloating,"
				"$mainMod, P, pseudo,"
				"$mainMod, T, togglesplit,"
				"$mainMod, M, exit,"

				# Move focus
				"$mainMod, h, movefocus, l"
				"$mainMod, l, movefocus, r"
				"$mainMod, k, movefocus, u"
				"$mainMod, j, movefocus, d"

				# Switch workspace with $mainMod + [0-9]
				"$mainMod, 1, workspace, 1"
				"$mainMod, 2, workspace, 2"
				"$mainMod, 3, workspace, 3"
				"$mainMod, 4, workspace, 4"
				"$mainMod, 5, workspace, 5"
				"$mainMod, 6, workspace, 6"
				"$mainMod, 7, workspace, 7"
				"$mainMod, 8, workspace, 8"
				"$mainMod, 9, workspace, 9"

				# Move window to workspace with $mainMod + SHIFT + [0-9]
				"$mainMod SHIFT, 1, movetoworkspace, 1"
				"$mainMod SHIFT, 2, movetoworkspace, 2"
				"$mainMod SHIFT, 3, movetoworkspace, 3"
				"$mainMod SHIFT, 4, movetoworkspace, 4"
				"$mainMod SHIFT, 5, movetoworkspace, 5"
				"$mainMod SHIFT, 6, movetoworkspace, 6"
				"$mainMod SHIFT, 7, movetoworkspace, 7"
				"$mainMod SHIFT, 8, movetoworkspace, 8"
				"$mainMod SHIFT, 9, movetoworkspace, 9"

				# Scroll through workspaces with $mainMod + scroll
				"$mainMod, mouse_down, workspace, e+1"
				"$mainMod, mouse_up  , workspace, e-1"
			];

			# Move/resize windows with $mainMod + LMB/RMB and dragging
			bindm = [
				"$mainMod, mouse:272, movewindow"
				"$mainMod, mouse:273, resizewindow"
			];

		# l -> do stuff even when locked
		# e -> repeats when key is held 
			bindl = [
				", XF86AudioMute, exec, volumectl toggle-mute"
				", XF86AudioMicMute, exec, volumectl -m toggle-mute"
				"SHIFT, XF86AudioMute, exec, volumectl -m toggle-mute"
				", XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles "
				", XF86AudioNext, exec, playerctl next "
				", XF86AudioPrev, exec, playerctl previous"
			];

			bindle = [
				", XF86AudioRaiseVolume, exec, volumectl -u up 10"
				", XF86AudioLowerVolume, exec, volumectl -u down 10"
				"SHIFT, XF86AudioRaiseVolume, exec, volumectl -mu up 10"
				"SHIFT, XF86AudioLowerVolume, exec, volumectl -mu down 10"

				", XF86MonBrightnessUp, exec, lightctl up 10"
				", XF86MonBrightnessDown, exec, lightctl down 10"
				", XF86Search, exec, $launcher"
			];

			input = {
				kb_layout = "no";
				follow_mouse = 1;
				touchpad = {
					natural_scroll = true;
				};
				sensitivity = 0.0;
				accel_profile = "flat";
			};

			general = {
				gaps_in = 20;
				gaps_out = 20;
				border_size = 2;
				"col.active_border" = "rgba(${config.colorScheme.colors.base04}ee) rgba(${config.colorScheme.colors.base05}ee) 45deg";
				"col.inactive_border" = "rgba(${config.colorScheme.colors.base00}aa)";
				layout = "dwindle";
				allow_tearing = "false";
			};

			decoration = {
				rounding = 10;
				blur = {
					enabled = true;
					size = 3;
					passes = 1;
					vibrancy = 0.1696;
				};
				drop_shadow = true;
				shadow_range = 4;
				shadow_render_power = 3;
				"col.shadow" = "rgba(1a1a1aee)";
			};

			animations = {
				enabled = "true";
				bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

				animation = [
					"windows, 1, 7, myBezier"
					"windowsOut, 1, 7, myBezier, popin 80%"
					"border, 1, 10, default"
					"borderangle, 1, 8, default"
					"fade, 1, 7, default"
					"workspaces, 1, 6, default"
				];
			};

			dwindle = {
				pseudotile = "true";
				preserve_split = "true";
			};

			master = {
				new_is_master = "true";
			};

			gestures = {
				workspace_swipe = false;
			};

			misc = {
				force_default_wallpaper = 0;
				# disable_hyprland_logo = true
			};

			windowrulev2 = [
				"nomaximizerequest, class:.*"
			];
		};
	};
}
