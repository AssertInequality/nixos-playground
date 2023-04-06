{ config, pkgs, ... }:

{

  imports =
    [
      <home-manager/nixos>
      ./user.d/home.nix
    ];

}
