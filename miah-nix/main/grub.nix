  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
  	enable = true;
  	useOSProber = true;
	  efiSupport = true;
	  devices = [ "nodev" ];
  };

  boot.loader.efi.canTouchEfiVariables = true;
