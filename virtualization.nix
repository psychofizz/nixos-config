# virtualization.nix
{ config, pkgs, ... }:

{
  # Enable virt-manager
  programs.virt-manager.enable = true;

  # Add your user to libvirtd group
  users.groups.libvirtd.members = [ "your_username" ];

  # Enable libvirtd service
  virtualisation.libvirtd.enable = true;

  # Enable SPICE USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
}

