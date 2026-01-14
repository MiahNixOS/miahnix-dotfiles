{ config, pkgs, lib, ... }:

{
  services.ollama = { 
  	enable = true; 
  };


#  Reboot unless nvidia-smi ok 
#  hardware.graphics.enable = true;
#  services.xserver.videoDrivers = [ "nvidia" ]; 
#  hardware.nvidia = { open = false; modesetting.enable = true; }; 
#  nixpkgs.config.allowUnfree = true; 
  nixpkgs.config.allowUnfreePredicate = pkg: 
  builtins.elem (lib.getName pkg) [ "cuda" "cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" "nvidia-settings" "nvidia-x11" ]; 
#   #nixpkgs.config.nvidia.acceptLicense = true;
}
 
