{

  systemd.services.docker.unitConfig = {
    # 'Requires' ensures the mount unit is started along with Docker
    Requires = [ "mnt-MacStore.mount" "..." ];
    # 'After' ensures the mount unit is started *before* Docker
    After = [ "mnt-MacStore.mount" "..." ];
  };

    virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      data-root = "/mnt/MacStore/docker";
      # Requires = "mnt-MacStore.mount";
      # After = "mnt-MacStore.mount";
    };
  };
}
