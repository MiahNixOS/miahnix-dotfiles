{ config, pkgs, ... }:

{
  fileSystems."/mnt/MacStore" = {
    device = "/dev/disk/by-uuid/9ecb9c36-82ee-44d1-b671-05834fcd1cf";
    fsType = "xfs";
    options = [
      "defaults"
      "nofail"
    ];
  };
  fileSystems."/mnt/BoStore" = {
    device = "/dev/disk/by-uuid/7fea2b7e-92d1-445c-b21d-128ea399782";
    fsType = "xfs";
    options = [
      "defaults"
      "nofail"
    ];
  };
}
