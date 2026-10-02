# ./modules/audio-setup.nix
{pkgs, ...}: let
  # ---- Tunables: change these, everything below follows ----
  sampleRate = 48000; # Ui24 only advertises 48k over USB
  quantum = 256; # graph buffer (a.k.a. blocksize) in frames
  periodSize = 64; # ALSA period for the Ui24 node
  minQuantum = 64; # let the graph negotiate down...
  maxQuantum = 1024; # ...and back off under load
  headroom = 128;

  # ---- Derived ----
  pwLatency = "${toString quantum}/${toString sampleRate}"; # PIPEWIRE_LATENCY hint

  # Ui24 PipeWire node names (from `wpctl inspect`)
  ui24Input = "alsa_input.usb-Soundcraft_Soundcraft_Ui24-00.multichannel-input";
  ui24Output = "alsa_output.usb-Soundcraft_Soundcraft_Ui24-00.multichannel-output";
in {
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
                { node.name = "${ui24Input}" }
                { node.name = "${ui24Output}" }
              ]
              actions = {
                update-props = {
                  audio.format = "S32LE"
                  audio.rate = ${toString sampleRate}
                  api.alsa.period-size = ${toString periodSize}
                  api.alsa.headroom = ${toString headroom}
                  session.suspend-timeout-seconds = 0
                }
              }
            }
          ]
        '')
      ];
    };

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = sampleRate;
        "default.clock.quantum" = quantum;
        "default.clock.min-quantum" = minQuantum;
        "default.clock.max-quantum" = maxQuantum;
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

  # Optional: make the latency hint the session-wide default (see caveat below)
  # environment.sessionVariables.PIPEWIRE_LATENCY = pwLatency;

  environment.systemPackages = with pkgs; [
    reaper
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
    yabridge
    yabridgectl
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
    (pkgs.writeShellScriptBin "reaper-audio" (let
      pluginLibs = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib # libstdc++.so.6
        pkgs.udev # libudev.so.1
        pkgs.xdotool # libxdo.so.3
        pkgs.xorg.libX11 # libX11.so.6
      ];
    in ''
      export PIPEWIRE_LATENCY=${pwLatency}
      export LD_LIBRARY_PATH=${pluginLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

      echo "=== reaper-audio diagnostics ==="
      echo "PIPEWIRE_LATENCY = $PIPEWIRE_LATENCY"
      echo "LD_LIBRARY_PATH  = $LD_LIBRARY_PATH"
      echo

      for so in \
        "$HOME/.config/REAPER/UserPlugins/reaper_helgobox-x64.so" \
        "$HOME/.config/REAPER/FX/helgobox-x64.so"
      do
        if [ -f "$so" ]; then
          echo "--- $so"
          missing=$(${pkgs.glibc.bin}/bin/ldd "$so" 2>/dev/null | grep 'not found' || true)
          if [ -n "$missing" ]; then
            echo "MISSING DEPS:"
            echo "$missing"
          else
            echo "all direct deps resolved"
          fi
          # real dlopen test (catches symbol version errors ldd misses)
          err=$(${pkgs.python3}/bin/python3 -c "import ctypes; ctypes.CDLL('$so')" 2>&1 || true)
          if [ -n "$err" ]; then
            echo "DLOPEN ERROR:"
            echo "$err" | tail -n1
          else
            echo "dlopen OK"
          fi
        else
          echo "--- $so: NOT FOUND on disk"
        fi
        echo
      done
      echo "================================"

      exec ${pkgs.pipewire.jack}/bin/pw-jack ${pkgs.reaper}/bin/reaper "$@"
    ''))
  ];
}
