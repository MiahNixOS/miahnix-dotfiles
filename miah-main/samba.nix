{ pkgs, config, ... }:
{
services.samba = {
  enable = true;
  #securityType = "user";
  # Open necessary ports in the firewall automatically
  openFirewall = true; 
  settings = {
    global = {
      "mangled names" = "no";
      "preserve case" = "yes";
      "workgroup" = "WORKGROUP";
      "server string" = "Samba Server";
      "server role" = "standalone server";
      "log file" = "/var/log/samba/%m.log";
      "max log size" = 50;
      "dns proxy" = "no";
      #"netbios name" = "miahnix";
      #"security" = "user";
      #"hosts allow" = "192.168. 127.0.0.1 localhost ::1";
      #"hosts deny" = "0.0.0.0/0";
      #"guest account" = "nobody";
      #"map to guest" = "bad user";
    };
    "MacStore" = {
      "path" = "/mnt/MacStore";
      "browsable" = "yes";
      "writeable" = "yes";
      "read only" = "no";
#      "create mask" = "0644";
#      "directory mask" = "0755";
      "guest ok" = "no"; # Require authentication for this specific share
      "valid users" = "archgodot"; # Specify which user can access
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Ensure the 'samba' package is installed for tools like smbpasswd
  environment.systemPackages = [
    pkgs.samba
  ];
}
