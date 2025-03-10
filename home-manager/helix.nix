{
  pkgs,
  helix-flake,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    rust-analyzer
    vscode-langservers-extracted
    yaml-language-server
    taplo
    nil
    nixpkgs-fmt
    alejandra
    lua-language-server
    tinymist
  ];
  programs = {
    helix = {
      package = helix-flake.packages.${pkgs.system}.default;
      enable = true;
      defaultEditor = true;
      settings = {
        theme = lib.mkForce "kanagawa";

        editor = {
          auto-completion = false;
          auto-format = true;
          scrolloff = 10;
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          true-color = true;
          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "disable";
          };
          search = {
            wrap-around = true;
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "block";
          };
          indent-guides = {
            render = true;
            character = "·";
          };
          file-picker.hidden = false;
        };
        keys = {
          normal = {
            space = {
              "E" = ":reload-all";
              "L" = ":lsp-restart";
              "I" = ":toggle-option lsp.display-inlay-hints";
              "O" = ":toggle inline-diagnostics.cursor-line disable warning";
            };
          };
          insert = {
            C-a = "goto_first_nonwhitespace";
            C-e = "goto_line_end_newline";
          };
          select = {
            esc = ["normal_mode"];
          };
        };
      };
      languages = {
        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
          }
          {
            name = "toml";
            auto-format = true;
          }
          {
            name = "typst";
            language-servers = ["tinymist"];
          }
        ];
        language-server.rust-analyzer = {
          command = "rust-analyzer";
          config = {
            command = "clippy";
            extraArgs = ["--tests"];
            checkOnSave = {
              command = "clippy";
              extraArgs = ["--tests"];
            };
          };
        };
        language-server.tinymist = {
          command = "tinymist";
          config = {
            formatterMode = "typstyle";
          };
        };
        language-server.nil = {
          command = "nil";
          config = {
            nix = {
              flake = {
                autoEvalInputs = true;
                autoArchive = true;
              };
              maxMemoryMB = 8192;
            };
            formatting.command = ["alejandra" "--"];
          };
        };
      };
    };
  };
}
