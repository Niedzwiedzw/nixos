{pkgs ? import <nixpkgs> {}}:
(pkgs.buildFHSEnv {
  name = "opennox";
  targetPkgs = pkgs:
    (with pkgs; [
      udev
      alsa-lib
    ])
    ++ (with pkgs; [
      pkgsi686Linux.libglvnd # 32-bit OpenGL compatibility libraries
      pkgsi686Linux.openalSoft # 32-bit OpenAL library
    ]);
  # multiPkgs = pkgs: (with pkgs; [
  #   udev
  #   alsa-lib
  # ]);
  runScript = "lutris";
})
.env
