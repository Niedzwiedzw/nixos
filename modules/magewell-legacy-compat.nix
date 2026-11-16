{ inputs, ... }:
{
  hardware.mwProCapture.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [
        (kernelFinal: _: {
          mwprocapture = final.callPackage "${inputs.nixpkgs-unstable}/pkgs/os-specific/linux/mwprocapture" {
            inherit (kernelFinal) kernel stdenv;
          };
        })
      ];
    })
  ];
}
