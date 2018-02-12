# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 boot.kernelParams = [ "intel_pstate=no_hwp"];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/c0953bab-e048-4024-b98d-6d814bcd3d88";
      preLVM = true;
      allowDiscards = true;
    }
  ];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;
  hardware.enableAllFirmware = true;
  networking.hostName = "waco"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 waco
  '';
  # Select internationalisation properties.
  i18n = {
   # consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "no-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  nixpkgs.config = 
  {
    # Allow proprietary packages
    allowUnfree = true;

    # Create an alias for the unstable channel
    packageOverrides = pkgs: 
    {
      polybar = pkgs.polybar.override {
        alsaSupport = true;
        i3GapsSupport = true;
        iwSupport = true;
        githubSupport = true;
        mpdSupport = true;
      };
    unstable = import <nixos-unstable> 
      { 
        # pass the nixpkgs config to the unstable alias
        # to ensure `allowUnfree = true;` is propagated:
        config = config.nixpkgs.config; 
      };
    };
  };

  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    wget
    bc 
    vim 
    curl 
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
    proxychains
    xcalib
    termite
    gnupg
    pinentry
    python36
    python27
    compton
    gitAndTools.gitFull
    gitAndTools.hub
    unstable.slack
    spotify
    synergy
    thermald
    quicksynergy
    httpie
    bind
    arandr
    siege
    powertop
    usbutils
    yubikey-personalization
    libressl
    file
    git-crypt
    awscli
    gettext
    polybar
    dunst
    libnotify
    jq
    scrot
    xclip
    nox
    tcpdump
    wireshark
    openvpn
    neofetch
    neovim
    nox
    ranger
    scrot
    xclip
  ];
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.fish.enable = true;
  programs.light.enable = true;
  services.tlp.enable = true;
  services.openssh.enable = true;
  services.acpid.enable = true;
  services.thermald.enable = true;
  services.synergy.server.enable = true;
  services.synergy.server.autoStart = true;
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
  networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  #networking.firewall.enable = false;

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
      unifont
      siji
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.davalex = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker"];
    #shell = "/run/current-system/sw/bin/fish";
  };
  virtualisation.docker.enable = true;
  system.stateVersion = "17.09"; # Did you read the comment?

}
