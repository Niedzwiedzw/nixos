{pkgs, ...}: let
  whisper-pl = pkgs.writeShellScriptBin "whisper-pl" ''
    ${pkgs.openai-whisper}/bin/whisper --language Polish --device cuda --model turbo "$@"
  '';
in {
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  users.users.niedzwiedz.extraGroups = ["video" "render"];

  environment.systemPackages = with pkgs; [
    openai-whisper
    ffmpeg
    whisper-pl
    rocmPackages.rocm-smi # useful for checking GPU status
  ];

  # Set environment variables for PyTorch ROCm
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
