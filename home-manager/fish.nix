{pkgs, ...}: {
  home.packages = with pkgs; [
    fish

    fishPlugins.done
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    fzf
    grc
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    # plugins = with pkgs.fishPlugins; [
    #   {
    #     name = "done";
    #     src = done.src;
    #   }
    #   {
    #     name = "forgit";
    #     src = forgit.src;
    #   }
    #   {
    #     name = "hydro";
    #     src = hydro.src;
    #   }
    #   {
    #     name = "grc";
    #     src = grc.src;
    #   }
    # ];

    shellAliases = {
      # llm wrapper
      "llm" = "uv --directory ~/nixos/nix-shells/llm-shell run llm";
      # zellij helper
      "zz" = "zellij attach -c (echo $PWD | string replace -a '/' '-' | string trim --chars=-)";
      "firefox-nightly" = "/home/niedzwiedz/nixos/scripts/firefox-nightly";
      # movement
      "htop" = "btm";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";

      "cp" = "cp -v";
      "cat" = "bat";
      "ddf" = "df -h";
      "mkdir" = "mkdir -p";
      "mv" = "mv -v";
      "rm" = "rm -v";

      "ls" = "eza -lhr -s time --no-quotes --time-style long-iso";
      "ld" = "eza -ld */ --no-quotes --time-style long-iso";
      "lla" = "eza -lah --no-quotes --time-style long-iso";
      "ll" = "eza -lh --no-quotes --time-style long-iso";
      "llr" = "eza -lhr --no-quotes --time-style long-iso";
      "lls" = "eza -lh -s size --no-quotes --time-style long-iso";
      "llt" = "eza -lh -s time --no-quotes --time-style long-iso";
      "lltr" = "eza -lhr -s time --no-quotes --time-style long-iso";

      "jpeg" = "feh -Z *.jpeg";
      "jpg" = "feh -Z *.jpg";
      "png" = "feh -Z *.png";
    };

    shellAbbrs = {
      # nix helpers
      "nixrebuild" = "cd ~/nixos/ && sudo nixos-rebuild switch --flake ~/nixos/#niedzwiedz --upgrade && home-manager switch -b backup --flake ~/nixos/#niedzwiedz && git add . && git commit -m 'quick rebuild' && cd -";
      # git abbreviations
      ggf = "git push --force-with-lease origin $(git rev-parse --abbrev-ref HEAD)";
      ggp = "git push origin $(git rev-parse --abbrev-ref HEAD)";
      ggu = "git pull --rebase origin $(git rev-parse --abbrev-ref HEAD)";
      gaa = "git add -A";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gcm = "git commit -m";
      gcob = "git checkout -b";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gpom = "git push origin main";
      gs = "git status";
      gst = "git stash";
      gstp = "git stash pop";
    };

    functions = {
      extract = ''
        function extract
           switch $argv[1]
               case "*.tar.bz2"
                   tar xjf $argv[1]

               case "*.tar.gz"
                   tar xzf $argv[1]

               case "*.bz2"
                   bunzip2 $argv[1]

               case "*.rar"
                   unrar e $argv[1]

               case "*.gz"
                   gunzip $argv[1]

               case "*.tar"
                   tar xf $argv[1]

               case "*.tbz2"
                   tar xjf $argv[1]

               case "*.tgz"
                   tar xzf $argv[1]

               case "*.zip"
                   unzip $argv[1]

               case "*.Z"
                   uncompress $argv[1]

               case "*.7z"
                   7z x $argv[1]

               case "*"
                   echo "unknown extension: $argv[1]"
           end
        end
      '';

      extracttodir = ''
        function extracttodir
            switch $argv[1]
                case "*.tar.bz2"
                    tar -xjf $argv[1] -C "$argv[2]"

                case "*.tar.gz"
                    tar -xzf $argv[1] -C "$argv[2]"

                case "*.rar"
                    unrar x $argv[1] "$argv[2]/"

                case "*.tar"
                    tar -xf $argv[1] -C "$argv[2]"

                case "*.tbz2"
                    tar -xjf $argv[1] -C "$argv[2]"

                case "*.tgz"
                    tar -xzf $argv[1] -C "$argv[2]"

                case "*.zip"
                    unzip $argv[1] -d $argv[2]

                case "*.7z"
                    7za e -y $argv[1] -o"$argv[2]"

                case "*"
                    echo "unknown extension: $argv[1]"
            end
        end
      '';

      num = ''
        function num
        	ls -1 $argv | wc -l;
        end
      '';

      wg = ''
        function wg
           set -l num_args (count $argv)

           if test $num_args -eq 1
               wget -c $argv[1]

           else if test $num_args -eq 2
               # arg1 = name, arg2 = url
               wget -c -O $argv[1] $argv[2]

           else
               echo "Incorrect number of arguments"
           end
        end
      '';

      ytd = ''
        function ytd
          mkdir -p "$HOME/Videos"

          yt-dlp \
            -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' \
            -o "$HOME/Videos/%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s" \
            --sponsorblock-mark all \
            --geo-bypass \
            --sub-langs all \
            --embed-subs \
            --embed-metadata \
            --convert-subs srt \
            --exec "after_move:fish -c '
              set src \$argv[1]
              set size (stat -c %s \"\$src\")

              if test \$size -le 19000000
                exit 0
              end

              set duration (ffprobe -v error -show_entries format=duration -of csv=p=0 \"\$src\")
              set bitrate (math -s0 \"(19000000 * 8 / \$duration - 96000) / 1000\")
              set bitrate (math \"max(10, \$bitrate)\")

              set tmp (mktemp --suffix=.mp4)

              ffmpeg -y -i \"\$src\" \
                -c:v libx264 -b:v \"\$bitrate\"k \
                -pix_fmt yuv420p \
                -c:a aac -b:a 96k \
                -map 0:v:0 -map 0:a? -sn \
                -movflags +faststart \"\$tmp\"

              if test \$status -eq 0; and test (stat -c %s \"\$tmp\") -le 20000
                mv -f \"\$tmp\" \"\$src\"
              else
                echo \"Compression failed or exceeded 25 MB: \$src\" >&2
                rm -f \"\$tmp\"
              end
            ' -- %(filepath)q" \
            $argv
        end
      '';
    };
  };
}
