{ config, pkgs, inputs, ... }:

{
	programs.firefox = {
		enable = true;
		# package = pkgs.firefox;
		profiles.olai = {
			bookmarks = [
				{
					name = "wikipedia";
					tags = [ "wiki" ];
					keyword = "wiki";
					url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
				}
			];

			search.default = "DuckDuckGo";

			search.engines = {
				"Nix Packages" = {
					urls = [{
						template = "https://search.nixos.org/packages?channel=unstable";
						params = [
							{ name = "type"; value = "packages"; }
							{ name = "query"; value = "{searchTerms}"; }
						];
					}];

					icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					definedAliases = [ "@np" ];
				};

				"Nix Options" = {
					urls = [{
						template = "https://search.nixos.org/options?channel=unstable";
						params = [
							{ name = "type"; value = "options"; }
							{ name = "query"; value = "{searchTerms}"; }
						];
					}];

					icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					definedAliases = [ "@no" ];
				};

				"Home-Manager Options" = {
					urls = [{
						template = "https://mipmip.github.io/home-manager-option-search";
						params = [
							{ name = "query"; value = "{searchTerms}"; }
						];
					}];

					icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
					definedAliases = [ "@hm" ];
				};
			};
			search.force = true;

			extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
				ublock-origin
				sponsorblock
				darkreader
				youtube-shorts-block
			];
		};
	};
}
