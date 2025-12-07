{ config, pkgs, inputs, ... }:

{
  home.username = "saikofisu";
  home.homeDirectory = "/home/saikofisu";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # --- Fonts (Required for the terminal ricing) ---
    fira-code
    nerd-fonts.symbols-only
    nerd-fonts.fira-code

    # --- Multimedia & Graphics ---
    audacity
    krita
    kdePackages.kdenlive
    kdePackages.plasma-browser-integration
    handbrake
    obs-studio
    inkscape
    antigravity
    kdePackages.marknote
    inputs.wfetch.packages.${pkgs.system}.default
    libreoffice
    anki

    # --- Video & Audio Players ---
    mpv

    # --- Communication ---
    telegram-desktop
    discord
    kdePackages.kdeconnect-kde

    # --- Development & Utilities ---
    vscode-fhs
    yt-dlp
    kdePackages.ktorrent
    moonlight-qt
    ungoogled-chromium

    # --- Productivity & Other ---
    anki
    spotify
    steam

    # --- CLI Fun ---
    spotify-player
    spotifyd
    spotify-qt
    cmatrix
    cowsay
    asciiquarium
    genact
    discordo
    youtube-tui
  ];

  # ... (Keep your xdg.desktopEntries here if you have them) ...

  programs = {
    # --- Git ---
    git = {
      enable = true;
      # The trace requested moving these into 'settings'
      settings = {
        user = {
          name = "saikofisu";
          email = "psychofizz@pm.me";
        };
        alias = {
          ci = "commit";
          co = "checkout";
          s = "status";
        };
      };
    };

    # --- Kitty (Riced) ---
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Mocha";
      font = {
        name = "Fira Code";
        size = 10;
      };

      settings = {
        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        enable_audio_bell = false;
        mouse_hide_wait = "-1.0";
        window_padding_width = 4;

        # Visuals
        background_opacity = "0.95";
        background_blur = 1;

        # Advanced Symbol Mapping (Nerd Fonts)
        symbol_map = let
          mappings = [
            "U+23FB-U+23FE" "U+2B58" "U+E200-U+E2A9" "U+E0A0-U+E0A3"
            "U+E0B0-U+E0BF" "U+E0C0-U+E0C8" "U+E0CC-U+E0CF" "U+E0D0-U+E0D2"
            "U+E0D4" "U+E700-U+E7C5" "U+F000-U+F2E0" "U+2665" "U+26A1"
            "U+F400-U+F4A8" "U+F67C" "U+E000-U+E00A" "U+F300-U+F313"
            "U+E5FA-U+E62B"
          ];
        in
          (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        # ... other settings
      };
    };
  };
}
