{ config, pkgs, inputs, ... }:

{
	home.packages = with pkgs; [
    inputs.gross.packages.${pkgs.system}.gross
	];


	programs.eww = {
		enable = true;
		package = pkgs.eww-wayland;
		# configDir = ./eww;
	};

	xdg.configFile."eww/eww.yuck" = ''
(deflisten hyprland "gross hyprland")

(defvar monitor_colors `["ws-red", "ws-yellow", "ws-green", "ws-blue"]`)

(defwidget workspaces []
	(eventbox
		:onscroll "echo {} | sed -e \"s/up/-1/g\" -r \"s/down/+1/g\" | xargs hyprctl dispatch workspace"
		(box
			:class "module workspaces"
			(for ws in {hyprland.workspaces}
				(button
					:onclick "hyprctl dispatch workspace ''${ws.name}"
					:class `ws icon ''${ws.state == "Active" ? monitor_colors[ws.monitor] : ""}`
					(box
						:class `''${ws.name == hyprland.focused ? "focused" : ""}`
						:height 3
					)
				)
			)
		)
	)
)


(defwidget left []
	(box
		:space-evenly false
		:halign "start"
		(workspaces)
	)
)

(defwidget center []
	(box
		:space-evenly false
		:halign "center"
	)
)

(defwidget right []
	(box
		:space-evenly false
		:halign "end"
	)
)

(defwidget bar-box []
	(centerbox
		(left)
		(center)
		(right)
	)
)


(defwindow bar
	:monitor 0
	:geometry (geometry
		:x "0%"
		:y "0%"
		:width "100%"
		:height "32px"
		:anchor "top center"
	)
	:stacking "fg"
	:exclusive true
	:namespace "bar"
	(bar-box)
)
	'';
}
