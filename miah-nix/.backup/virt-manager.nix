  # Virt-Manager
    boot.kernelModules = [ "kvm-amd" ];
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
        enable = true;
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

