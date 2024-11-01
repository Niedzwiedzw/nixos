with import <nixpkgs> {};
  mkShell {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgsi686Linux.libglvnd # 32-bit OpenGL compatibility libraries
      pkgsi686Linux.openalSoft # 32-bit OpenAL library
      # ...
    ];
    NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  }
