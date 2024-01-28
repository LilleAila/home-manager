{ config, pkgs, lib, inputs, ... }:

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
	];

	imports = [
		./waybar.nix
		# ./eww.nix
	];

	home.file."Wallpapers/hyprland_wallpaper.png".source = pkgs.runCommand "wallpaper" {} ''
	${pkgs.imagemagick}/bin/convert \
	-size 1920x1080 \
	gradient:'#${config.colorScheme.colors.base01}-#${config.colorScheme.colors.base00}' \
	-noise 2 \
	-blur 0x0.5 \
	-channel A \
	-evaluate Multiply 0.7 \
	+channel \( ${./hyprland_logo.png} -resize 500x500 \) \
	-geometry +50+50 \
	-gravity SouthWest \
	-composite \
	+channel \( ${./nixos_logo.png} -resize 500x500 \) \
	-geometry +50+50 \
	-gravity SouthEast \
	-composite \
	png:- > $out
	'';

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

	programs.wlogout = {
		enable = true;
		package = pkgs.wlogout;
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

	wayland.windowManager.hyprland = {
		enable = true;
		enableNvidiaPatches = true;
		systemd.enable = true;
		xwayland.enable = true;
		extraConfig = ''
		monitor=eDP-1,preferred,auto,1

		exec-once = swww init && swww img ~/Wallpapers/hyprland_wallpaper.png
		exec-once = hyprctl setcursor "Bibata-Modern-Ice" 24 &
		exec-once = nm-applet --indicator &
		# exec-once = eww daemon && eww open bar
		exec-once = waybar &
		exec-once = mako &
		# exec-once = armcord &

		$terminal = kitty
		$fileManager = dolphin
		$webBrowser = qutebrowser
		$launcher = rofi -show drun -show-icons
		$screenshot = grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | swappy -f - &
		$edit_image = wl-paste | swappy -f - &
		env = XCURSOR_SIZE,24

		$mainMod = SUPER
		
		bind = $mainMod, S, exec, $screenshot
		bind = $mainMod SHIFT, S, exec, $edit_image

		bind = $mainMod, return, exec, $terminal
		bind = $mainMod, space, exec, $launcher
		bind = $mainMod, W, killactive,
		bind = $mainMod, E, exec, $fileManager
		bind = $mainMod, B, exec, $webBrowser
		bind = $mainMod, O, fullscreen, 0
		bind = $mainMod SHIFT, O, fullscreen, 1
		bind = $mainMod, F, togglefloating,
		bind = $mainMod, P, pseudo,
		bind = $mainMod, T, togglesplit,
		bind = $mainMod, M, exit,

		bind = $mainMod, h, movefocus, l
		bind = $mainMod, l, movefocus, r
		bind = $mainMod, k, movefocus, u
		bind = $mainMod, j, movefocus, d

		# Switch workspace with $mainMod + [0-9]
		bind = $mainMod, 1, workspace, 1
		bind = $mainMod, 2, workspace, 2
		bind = $mainMod, 3, workspace, 3
		bind = $mainMod, 4, workspace, 4
		bind = $mainMod, 5, workspace, 5
		bind = $mainMod, 6, workspace, 6
		bind = $mainMod, 7, workspace, 7
		bind = $mainMod, 8, workspace, 8
		bind = $mainMod, 9, workspace, 9

		# Move window to workspace with $mainMid + SHIFT + [0-9]
		bind = $mainMod SHIFT, 1, movetoworkspace, 1
		bind = $mainMod SHIFT, 2, movetoworkspace, 2
		bind = $mainMod SHIFT, 3, movetoworkspace, 3
		bind = $mainMod SHIFT, 4, movetoworkspace, 4
		bind = $mainMod SHIFT, 5, movetoworkspace, 5
		bind = $mainMod SHIFT, 6, movetoworkspace, 6
		bind = $mainMod SHIFT, 7, movetoworkspace, 7
		bind = $mainMod SHIFT, 8, movetoworkspace, 8
		bind = $mainMod SHIFT, 9, movetoworkspace, 9

		# Scroll through workspaces with $mainMod + scroll
		bind = $mainMod, mouse_down, workspace, e+1
		bind = $mainMod, mouse_up  , workspace, e-1

		# Move/resize windows with $mainMod + LMB/RMB and dragging
		bindm = $mainMod, mouse:272, movewindow
		bindm = $mainMod, mouse:273, resizewindow

		# l -> do stuff even when locked
		# e -> repeats when key is held 
		bindle = , XF86AudioRaiseVolume, exec, volumectl -u up 10
		bindle = , XF86AudioLowerVolume, exec, volumectl -u down 10
		bindl = , XF86AudioMute, exec, volumectl toggle-mute
		bindle = SHIFT, XF86AudioRaiseVolume, exec, volumectl -mu up 10
		bindle = SHIFT, XF86AudioLowerVolume, exec, volumectl -mu down 10
		bindl = , XF86AudioMicMute, exec, volumectl -m toggle-mute
		bindl = SHIFT, XF86AudioMute, exec, volumectl -m toggle-mute

		bindle = , XF86MonBrightnessUp, exec, lightctl up 10
		bindle = , XF86MonBrightnessDown, exec, lightctl down 10

		bindle = , XF86Search, exec, $launcher
		bindl = , XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles 
		bindl = , XF86AudioNext, exec, playerctl next 
		bindl = , XF86AudioPrev, exec, playerctl previous

    #### Other config

		input {
			kb_layout = no
				 follow_mouse = 1
			touchpad {
			  natural_scroll = true
			}
			sensitivity = 0.0
			accel_profile = flat
		}

		general {
			gaps_in = 20
			gaps_out = 20
			border_size = 2
			col.active_border = rgba(${config.colorScheme.colors.base04}ee) rgba(${config.colorScheme.colors.base05}ee) 45deg
			col.inactive_border = rgba(${config.colorScheme.colors.base00}aa)

			layout = dwindle
			allow_tearing = false
		}

		decoration {
			rounding = 10

			blur {
				enabled = true
				size = 3
				passes = 1
				vibrancy = 0.1696
			}
			
			drop_shadow = true
			shadow_range ) 4
			shadow_render_power = 3
			col.shadow = rgba(1a1a1aee)
		}

		animations {
			enabled = true

			bezier = myBezier, 0.05, 0.9, 0.1, 1.05

			animation = windows, 1, 7, myBezier
			animation = windowsOut, 1, 7, myBezier, popin 80%
			animation = border, 1, 10, default
			animation = borderangle, 1, 8, default
			animation = fade, 1, 7, default
			animation = workspaces, 1, 6, default
		}

		dwindle {
			pseudotile = true
			preserve_split = true
		}

		master {
			new_is_master = true
		}

		gestures {
			workspace_swipe = falsee
		}

		misc {
			force_default_wallpaper = 0
			# disable_hyprland_logo = true
		}

		windowrulev2 = nomaximizerequest, class:.*
		'';
	};
}
