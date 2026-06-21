{pkgs, ...}: {
  imports = [
    ./audio-setup/recording-session.nix
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-ui24r.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                { node.name = "alsa_input.usb-Soundcraft_Soundcraft_Ui24-00.multichannel-input" }
                { node.name = "alsa_output.usb-Soundcraft_Soundcraft_Ui24-00.multichannel-output" }
              ]
              actions = {
                update-props = {
                  audio.format = "S32LE"
                  audio.rate = 48000
                  api.alsa.period-size = 128
                  session.suspend-timeout-seconds = 0
                }
              }
            }
          ]
        '')
      ];
    };

    extraConfig.pipewire = {
      "92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 256;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 1024;
        };
      };
    };
  };

  musnix = {
    enable = true;
    kernel.realtime = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    # DAW
    reaper
    # plugins
    lsp-plugins
    chow-tape-model
    chow-phaser
    calf
    vital
    mda_lv2
    distrho-ports
    helm
    zam-plugins
    drumgizmo
    # vst bridging (yabridge pulls in its own pinned wine)
    yabridge
    yabridgectl
    # drivers, utils
    alsa-utils
    alsa-tools
    alsa-plugins
    alsa-firmware
    pipewire.jack
    qjackctl
    jack2
    jack-example-tools
    qpwgraph
    crosspipe
    pavucontrol
  ];
}
