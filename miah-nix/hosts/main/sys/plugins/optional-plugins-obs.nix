{ config, pkgs, ... }:

{
	# Plugins To Check Out:
	obs.studio-plugins = [
		obs-vnc # VNC viewer integrated into OBS as a source plugin
		pixel-art
		obs-noise # If I ever want to create noise?
		obs-markdown # Maybe helpful for Obsidian?
		obs-teleport # This Might Come In Handy! Send from 1 OBS to Another!
		droidcam-obs
		input-overlay
		obs-backgroundremoval
		obs-aitum-multistream


		# Maybe Useful
		obs-rgb-levels # Maybe useful?
		obs-multi-rtmp # Also maybe useful
		obs-text-pthread # And again maybe useful
		obs-shaderfilter
		obs-retro-effects
		obs-livesplit-one
		obs-freeze-filter
		obs-color-monitor
		looking-glass-obs
		obs-vintage-filter
		obs-scale-to-sound
		obs-media-controls
		obs-composite-blur
		obs-command-source
		obs-advanced-masks
		obs-stroke-glow-shadow
		obs-vertical-canvas
		obs-source-switcher
		obs-move-transition
		obs-gradient-source
		obs-transition-table
		obs-recursion-effect
		obs-scene-as-transition
		obs-browser-transition
		advanced-scene-switcher

		

		obs-dir-watch-media
		obs-dvd-screensaver
	];

}
