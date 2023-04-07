{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial;
  '';
  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixhost";
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Firewall
  # networking.firewall.checkReversePath = "loose";
  networking.firewall.enable = false;

  # User Management
  users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    hashedPassword = "hashed$P4ss";
    extraGroups = [ "wheel" "networkmanager" "docker" "lxd" ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    inetutils
    mtr
    sysstat
    tailscale
    git
    docker-compose
  ];

  ## Services

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enable Docker
  virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
  };
  
  virtualisation.lxd = {
      enable = true;
  };

  system.stateVersion = "22.11";

}
