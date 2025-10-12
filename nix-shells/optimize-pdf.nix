with import <nixpkgs> {}; let
  shrinkpdf = pkgs.writeShellScriptBin "shrinkpdf" ''
    #!/bin/bash
    # shrinkpdf.sh - Shrink PDF files using Ghostscript
    # Copyright (c) 2019-2023 Arnold Krille <arnold@arnoldkrille.com>
    # License: GPL-3.0-or-later
    #
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <https://www.gnu.org/licenses/>.

    set -euo pipefail

    # Default values
    QUALITY=1
    INPUT_FILE=""
    OUTPUT_FILE=""
    OVERWRITE=false
    VERBOSE=false
    HELP=false

    # Function to print usage
    usage() {
        cat << EOF
    Usage: $0 [OPTIONS] INPUT.pdf [OUTPUT.pdf]

    Shrink PDF files using Ghostscript.

    OPTIONS:
        -q, --quality LEVEL    Set quality level (0-10, default: 1)
                               0: screen (72dpi), 1: ebook (150dpi), 2: printer (300dpi),
                               3: prepress (300dpi, color), 4-10: higher quality
        -o, --output FILE      Output file (default: INPUT_shrunk.pdf)
        -f, --force            Overwrite output file if it exists
        -v, --verbose          Verbose output
        -h, --help             Show this help message

    EXAMPLES:
        $0 input.pdf
        $0 -q 2 -o output.pdf input.pdf
    EOF
    }

    # Function to print error and exit
    error() {
        echo "Error: $1" >&2
        exit 1
    }

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -q|--quality)
                QUALITY="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -f|--force)
                OVERWRITE=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                HELP=true
                shift
                break
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                if [[ -z "$INPUT_FILE" ]]; then
                    INPUT_FILE="$1"
                elif [[ -z "$OUTPUT_FILE" ]]; then
                    OUTPUT_FILE="$1"
                else
                    error "Too many arguments"
                fi
                shift
                ;;
        esac
    done

    # Show help if requested or no input file
    if [[ $HELP == true ]] || [[ -z "$INPUT_FILE" ]]; then
        usage
        exit 0
    fi

    # Check if input file exists
    if [[ ! -f "$INPUT_FILE" ]]; then
        error "Input file '$INPUT_FILE' does not exist"
    fi

    # Set output file if not specified
    if [[ -z "$OUTPUT_FILE" ]]; then
        OUTPUT_FILE="''${INPUT_FILE%.*}_shrunk.pdf"
    fi

    # Check if output file exists and overwrite is not allowed
    if [[ -f "$OUTPUT_FILE" ]] && [[ $OVERWRITE == false ]]; then
        error "Output file '$OUTPUT_FILE' already exists. Use -f to overwrite."
    fi

    # Check if Ghostscript is installed
    if ! command -v gs &> /dev/null; then
        error "Ghostscript is not installed. Please install it first."
    fi

    # Determine Ghostscript parameters based on quality level
    case $QUALITY in
        0)
            GS_DPI=72
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        1)
            GS_DPI=150
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        2)
            GS_DPI=300
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        3)
            GS_DPI=300
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        4)
            GS_DPI=600
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        5)
            GS_DPI=720
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        6)
            GS_DPI=1200
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        7)
            GS_DPI=2400
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        8)
            GS_DPI=3600
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        9)
            GS_DPI=4800
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        10)
            GS_DPI=6000
            GS_DEVICE=pdfwrite
            GS_OPTIONS="-dPDFSETTINGS=/prepress -dColorImageResolution=$GS_DPI -dGrayImageResolution=$GS_DPI -dMonoImageResolution=$GS_DPI -dNOPAUSE -dQUIET -dBATCH -sDEVICE=''${GS_DEVICE}"
            ;;
        *)
            error "Quality level must be between 0 and 10"
            ;;
    esac

    # Verbose output
    if [[ $VERBOSE == true ]]; then
        echo "Shrinking '$INPUT_FILE' to '$OUTPUT_FILE' with quality level $QUALITY ($GS_DPI dpi)"
        echo "Ghostscript command: gs $GS_OPTIONS -sOutputFile=\"$OUTPUT_FILE\" \"$INPUT_FILE\""
    fi

    # Run Ghostscript
    gs $GS_OPTIONS -sOutputFile="$OUTPUT_FILE" "$INPUT_FILE"

    # Check if output file was created
    if [[ ! -f "$OUTPUT_FILE" ]]; then
        error "Failed to create output file '$OUTPUT_FILE'"
    fi

    # Verbose output
    if [[ $VERBOSE == true ]]; then
        INPUT_SIZE=$(stat -f%z "$INPUT_FILE" 2>/dev/null || stat -c%s "$INPUT_FILE" 2>/dev/null)
        OUTPUT_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null)
        echo "Done. Input size: ''${INPUT_SIZE} bytes, Output size: ''${OUTPUT_SIZE} bytes"
        echo "Compression ratio: $(printf "%.1f" $(echo "scale=1; $OUTPUT_SIZE / $INPUT_SIZE * 100" | bc -l))%"
    fi

    echo "PDF shrunk successfully: $OUTPUT_FILE"
  '';
in
  mkShell {
    name = "pdf-optimizer-env";
    buildInputs = [
      ghostscript
      bc # For compression ratio calculation in verbose mode
      shrinkpdf
    ];
    shellHook = ''
      shrinkpdf --help
    '';
  }
