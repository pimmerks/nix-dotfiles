{ pkgs, user, ... }:
{
  # Add user to libvirtd group
  users.users.${user}.extraGroups = [ "libvirtd" ];

  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    adwaita-icon-theme
  ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
}
