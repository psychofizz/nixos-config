{ config, pkgs, lib, ... }:

let
  # Custom intel-vaapi-driver built from the patched source
  intel-vaapi-driver-custom = pkgs.stdenv.mkDerivation rec {
    pname = "intel-vaapi-driver";
    version = "2.4.4";

    # Use your local source directory
    src = pkgs.fetchFromGitHub {
      owner = "irql-notlessorequal";
      repo = "intel-vaapi-driver";
      rev = "0b648be50cd80e16469c135c76ff61bbd2f2d12b"; 
      sha256 = "0a0x7pgam7fkabry15kd2z6fdj6xgkqj3mjfdhr6q2m3il1h253v"; # Fill this after the first error
    };

    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
    ];

    buildInputs = with pkgs; [
      libva
      libdrm
      xorg.libX11
      wayland
    ];

    mesonFlags = [
      "-Dwith_x11=yes"
      "-Dwith_wayland_drm=auto"
      "-Denable_hybrid_codec=false"
      "-Denable_tests=false"
      "-Ddriverdir=${placeholder "out"}/lib/dri"
    ];

    enableParallelBuilding = true;

    meta = with lib; {
      description = "Intel VAAPI driver (custom patched version)";
      homepage = "https://github.com/irql-notlessorequal/intel-vaapi-driver";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
in
{
  # Override the system's intel-vaapi-driver with our custom version
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = intel-vaapi-driver-custom;
  };

  # Ensure the driver is installed and available
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver-custom
      intel-media-driver
    ];
  };

  # Set environment variables for VA-API
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };
}
