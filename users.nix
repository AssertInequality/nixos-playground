{ config, pkgs, ... }:

{
  imports =
    [
      ./users.d/main.nix
    ];


  # Disable root login by making users immutable
  users.mutableUsers = false;
  # Define a user account.
  users.users.user = {
    isNormalUser = true;
    hashedPassword = "password$hash123";
    extraGroups = [ "wheel" "docker" "lxd" ]; # Enable ‘sudo’ and LXD for the user.
    openssh.authorizedKeys.keys = [
      "key 1"
      "key 2"
    ];
  };


}

