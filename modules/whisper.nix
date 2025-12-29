{pkgs, ...}: let
  whisper-cpp-hip = pkgs.whisper-cpp.overrideAttrs (old: {
    cmakeFlags =
      (old.cmakeFlags or [])
      ++ [
        "-DGGML_HIP=ON"
        "-DAMDGPU_TARGETS=gfx1100"
        "-DCMAKE_HIP_ARCHITECTURES=gfx1100"
      ];
    buildInputs =
      (old.buildInputs or [])
      ++ [
        pkgs.rocmPackages.clr
        pkgs.rocmPackages.hipblas
        pkgs.rocmPackages.rocblas
      ];
  });

  modelName = "large-v3-turbo-q5_0";
  modelsPath = "/tmp/models";
  modelFullPath = "${modelsPath}/ggml-${modelName}.bin";
  whisper-pl = pkgs.writeShellScriptBin "whisper-pl" ''
    export HSA_OVERRIDE_GFX_VERSION=11.0.0
    set -e

    mkdir -p ${modelsPath}

    ${whisper-cpp-hip}/bin/whisper-cpp-download-ggml-model ${modelName} ${modelsPath}
    ${whisper-cpp-hip}/bin/whisper-cli --model ${modelFullPath} -l pl "$@"
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
    whisper-cpp-hip
    ffmpeg
    whisper-pl
    rocmPackages.rocm-smi # useful for checking GPU status
  ];

  # Set environment variables for PyTorch ROCm
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
