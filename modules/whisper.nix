{pkgs, ...}: let
  python-with-rocm = pkgs.python3.override {
    packageOverrides = self: super: {
      torch = super.torch-bin.override {
        openai-whisper = super.openai-whisper.override {
          torch = self.torch;
        };
      };
    };
  };

  openai-whisper-rocm = pkgs.openai-whisper.override {
    torch = pkgs.python3Packages.torchWithRocm;
  };
  whisper-pl = pkgs.writeShellScriptBin "whisper-pl" ''
    export HSA_OVERRIDE_GFX_VERSION=11.0.0
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
    python-with-rocm
    openai-whisper-rocm
    ffmpeg
    whisper-pl
    rocmPackages.rocm-smi # useful for checking GPU status
  ];

  # Set environment variables for PyTorch ROCm
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
