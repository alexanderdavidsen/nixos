# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./bootloader.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
  #   consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "no-latin1";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
   time.timeZone = "Europe/Oslo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
      wget 
      vim 
      curl 
      i3-gaps 
      i3blocks-gaps 
      i3lock-pixeled 
      fish 
      networkmanager 
      networkmanagerapplet 
      open-vm-tools 
      docker
      gnumake
      google-chrome
      firefox
      pavucontrol
      cmake
      p7zip
      rofi
      htop
      atop
      iotop
      strace
      acpi
      acpitool
      xorg.xbacklight
   ];
  nixpkgs.config.allowUnfree = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.fish.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.acpid.enable = true; 
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "no";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      vistafonts
      inconsolata
      terminus_font
      proggyfonts
      dejavu_fonts
      font-awesome-ttf
      ubuntu_font_family
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.davalex = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker"];
    shell = "/run/current-system/sw/bin/fish";
  };
  virtualisation.docker.enable = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
