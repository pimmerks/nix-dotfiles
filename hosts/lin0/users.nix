{
  pkgs,
  user,
  ...
}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = ["networkmanager" "wheel" "dialout"];
    packages = with pkgs; [
      firefox
      chromium
    ];
  };
}
