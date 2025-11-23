{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "saikofisu";
  home.homeDirectory = "/home/saikofisu";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
 home.packages = with pkgs; [

    # --- Multimedia & Graphics ---
    audacity
    krita
    kdePackages.kdenlive
    handbrake
    obs-studio
    inkscape
    inputs.antigravity-nix.packages.${pkgs.system}.default
    libreoffice

    # --- Video & Audio Players ---
    mpv

    # --- Communication ---
    telegram-desktop
    discord
    kdePackages.kdeconnect-kde

    # --- Development & Utilities ---
    vscode-fhs
    alacritty
    yt-dlp
    kdePackages.ktorrent
    moonlight-qt



    # --- Productivity & Other ---
    anki
    spotify
    steam

    # --- CLI Fun ---
    spotify-player
    cmatrix
    cowsay
    asciiquarium
    genact
    discordo
    youtube-tui
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/saikofisu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

    programs = {

    # --- Git Configuration ---
    git = {
      enable = true;
      userName = "saikofisu";
      userEmail = "psychofizz@pm.me";
    };

    # --- Vim Configuration ---
    vim = {
      enable = true;
      extraConfig = ''
        syntax on                 " Enable syntax highlighting
        filetype plugin indent on " Enable filetype-based indentation
        set number                " Show line numbers
        set relativenumber        " Show relative line numbers
        set mouse=a               " Enable mouse support
      '';
    };

    # --- Alacritty (Terminal) Configuration ---
    alacritty = {
      enable = true;
      settings = {
        font = {
          
          size = 10;
        };

        # Catppuccin Mocha Theme
        colors = {
          primary = {
            background = "0x1e1e2e";
            foreground = "0xcdd6f4";
          };
          cursor = {
            text = "0x1e1e2e";
            cursor = "0xf5e0dc";
          };
          normal = {
            black = "0x45475a";
            red = "0xf38ba8";
            green = "0xa6e3a1";
            yellow = "0xf9e2af";
            blue = "0x89b4fa";
            magenta = "0xf5c2e7";
            cyan = "0x94e2d5";
            white = "0xbac2de";
          };
          bright = {
            black = "0x585b70";
            red = "0xf38ba8";
            green = "0xa6e3a1";
            yellow = "0xf9e2af";
            blue = "0x89b4fa";
            magenta = "0xf5c2e7";
            cyan = "0x94e2d5";
            white = "0xa6adc8";
          };
        };
      };
    };

    # --- Starship (Prompt) Configuration ---
    starship = {
      enable = true;
      # This enables the starship prompt tool.
      # You must ALSO enable it for your specific shell.
      # See the examples below.
    };

    # --- Shell Configuration (Choose one) ---

    # Example: Enabling Starship for Bash
    # Uncomment this if you use Bash

    bash = {
      enable = true;
    };


    # Example: Enabling Starship for Zsh
    # Uncomment this if you use Zsh
    /*
    zsh = {
      enable = true;
      enableStarship = true;
    };
    */

    # Example: Enabling Starship for Fish
    # Uncomment this if you use Fish
    /*
    fish = {
      enable = true;
      enableStarship = true;
    };
    */
    home-manager = {
      enable = true;
    };
  };
}
