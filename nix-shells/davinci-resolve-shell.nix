{pkgs ? import <nixpkgs> {}}: let
  myBuildInputs = with pkgs; [
    glibc # Core C library
    libGL # OpenGL support
    # Pin Qt to 5.15 explicitly and include more modules
    (qt5.qtbase.override {qtCompatVersion = "5.15";})
    qt5.qtmultimedia
    qt5.qtdeclarative
    qt5.qtx11extras
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    zlib # Compression library
    xorg.libX11 # X11 dependencies
    xorg.libXext
    xorg.libXrandr
    mesa # OpenGL/Mesa for rendering
    # Uncomment if using NVIDIA GPU:
    # cudaPackages.cudatoolkit
  ];
in
  pkgs.mkShell {
    buildInputs = myBuildInputs;

    shellHook = ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath myBuildInputs}:$LD_LIBRARY_PATH
      export QT_PLUGIN_PATH=${pkgs.qt5.qtbase}/lib/qt-5.15/plugins
      echo "LD_LIBRARY_PATH set to: $LD_LIBRARY_PATH"
      echo "QT_PLUGIN_PATH set to: $QT_PLUGIN_PATH"
      echo "Qt version: $(qmake --version)"
    '';
  }
