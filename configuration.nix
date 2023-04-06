{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # set up Networking
  networking.hostName = "nixhost"; # Define your hostname.
  networking.networkmanager.enable = false;
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.interfaces.enp9s0.useDHCP = false;
  systemd.network = {
      enable = true;
      netdevs = {
          bridge0 = {
              netdevConfig = { Kind = "bridge"; Name = "bridge0"; };
          };
      };
      networks = {
          "15-bridge0-bind" = {
              name = "enp9s0";
              bridge = [ "bridge0" ];
          };
          "10-bridge0" = {
              matchConfig = {Name = "bridge0"; Type = "bridge"; };
              address = [ "192.168.1.200/24" ];
              gateway = [ "192.168.1.1" ];
              dns = [ "1.1.1.1" "1.0.0.1" ];
          };
      };
      wait-online.ignoredInterfaces = [
        "bridge0" "bridge0-bind" "enp9s0"
      ];
      wait-online.timeout = 0;
  };

  # Set your time zone.
  # time.timeZone = "";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    lm_sensors
    samba4Full
    tailscale
    docker-compose
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };

  # Enable Tailscale
  services.tailscale.enable = true;

  networking.firewall.enable = false;

  # Enable Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  security.apparmor.enable = true;

  ## Enable LXD virtualization
  virtualisation.lxd = {
      enable = true;
  };

  ## Enabling Docker
  virtualisation.docker.enable = true;

  # Main Version
  system.stateVersion = "22.11";

}

