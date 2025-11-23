# cursor-free-vip.nix
# A Nix expression to package a pre-compiled binary ("CursorFreeVIP")
# using buildFHSEnv.

# This function expects 'pkgs' to be passed in,
# which it will be by default when imported from your configuration.
{ pkgs ? import <nixpkgs> {} }:

let

  # --- STEP 1 ---
  # First, we create a basic derivation that just copies your
  # binary file into the Nix store. We don't try to "fix" it here.
  # We just give it a standard location in $out/bin.
  cursor-free-vip-bin = pkgs.stdenv.mkDerivation rec {
    pname = "cursor-free-vip-bin";
    version = "1.11.03";

    # --- !!! IMPORTANT !!! ---
    # This 'src' path assumes your binary 'CursorFreeVIP_1.11.03_linux_x64'
    # is in the *same directory* as this 'cursor-free-vip.nix' file.
    #
    # If it's still in ~/Downloads, either move it here or change
    # this path to be absolute, e.g.:
    # src = /home/your-user-name/Downloads/CursorFreeVIP_1.11.03_linux_x64;
    # -------------------------
    src = ./CursorFreeVIP_1.11.03_linux_x64;

    # This file is a single executable, not a .tar.gz or .zip
    dontUnpack = true;

    # We don't need a build phase
    dontBuild = true;

    # We just need to copy the file into $out/bin
    installPhase = ''
      runHook preInstall
      
      # Create the destination directory
      mkdir -p $out/bin
      
      # Copy the binary and give it a simpler, generic name
      cp $src $out/bin/cursor-free-vip
      
      # Ensure the binary is executable
      chmod +x $out/bin/cursor-free-vip
      
      runHook postInstall
    '';

    # We're not patching anything here, so we skip the fixup phase.
    # The FHS env will handle the libraries.
    dontFixup = true;
  };

in # End of 'let' block

  # --- STEP 2 ---
  # Now, we create the FHS environment. This derivation
  # wraps the 'cursor-free-vip-bin' package from above.
  pkgs.buildFHSEnv {
    # This will be the name of the final package
    name = "cursor-free-vip";

    # Tell the FHS env which package's executables to wrap.
    # In this case, it's the 'cursor-free-vip-bin' package.
    targetPkgs = pkgs: [
      cursor-free-vip-bin
    ];

    # --- This is the most important part ---
    # We provide a list of libraries to mount inside the
    # FHS "bubble." This list is a "best guess" for a
    # typical modern GUI application.
    #
    # If the app still fails to start, you may need to
    # add more libraries to this list by looking at
    # its error messages.
    libraries = with pkgs; [
      # Standard C and C++ libraries
      glibc
      stdenv.cc.cc # Provides libstdc++

      # Common GUI and audio libraries
      alsa-lib
      dbus
      gtk3  # A very common GUI toolkit
      qt5.qtbase # The other common GUI toolkit (safe to include both)
      pulseaudio

      # X11 libraries (for windowing)
      xorg.libX11
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXi
      xorg.libxkbcommon

      # Font and text rendering
      fontconfig
      freetype
      cairo
      pango
      gdk-pixbuf

      # Networking and security
      openssl
      nss
    ];

    # This will create a final package with a wrapper script at
    # $out/bin/cursor-free-vip. When you run it, it will
    # first set up the FHS bubble, then execute the "real"
    # binary from the -bin package inside it.
  }
