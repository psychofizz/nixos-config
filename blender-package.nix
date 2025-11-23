{ pkgs ? import <nixpkgs> {} }: # Define default pkgs argument

# This function takes a 'pkgs' set and returns the Blender derivation
pkgs.stdenv.mkDerivation rec {
  pname = "blender";
  version = "3.6.22";

  # Use 'pkgs.' prefix for all dependencies
  src = pkgs.fetchurl {
    url = "https://download.blender.org/release/Blender3.6/blender-3.6.22-linux-x64.tar.xz";
    # **IMPORTANT:** Use your correct SHA-256 hash here.
    sha256 = "sha256-WVPIf21INgUGGng5dYUnxny4ITjQ01kPktjHarx1dgA=";
  };

  # 2. Packaging Binary Dependencies
  nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];

  # Example runtime dependencies (you must verify these)
  buildInputs = [
    pkgs.xorg.libXrandr
    pkgs.xorg.libXxf86vm
    pkgs.openal
    pkgs.libglvnd
    # Add more pkgs.dependencies here...
  ];

  # 3. Installation Phase
  installPhase = ''
    # Find the main unpacked directory (e.g., blender-3.6.0-linux-x64)
    BLENDER_DIR=$(find . -maxdepth 1 -type d -name "blender-*" -o -name "Blender*")

    # Install the contents into the $out directory
    mkdir -p $out/bin $out/share
    
    cp -r $BLENDER_DIR/* $out/share/
    
    # Use makeWrapper to set up the execution environment
    pkgs.makeWrapper $out/share/blender $out/bin/blender \
      --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
  '';

  meta = with pkgs.lib; {
    description = "A free and open source 3D creation suite";
    homepage = "https://www.blender.org/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
