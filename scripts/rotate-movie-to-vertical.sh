#!/usr/bin/env bash

# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 input_video [clockwise|counterclockwise]"
    exit 1
fi
# Input file
input_file="$1"
direction="$2"

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found"
    exit 1
fi
# Validate direction parameter
case "$direction" in
    "clockwise")
        transpose_value=1
        ;;
    "counterclockwise")
        transpose_value=2
        ;;
    *)
        echo "Error: Direction must be 'clockwise' or 'counterclockwise'"
        exit 1
        ;;
esac
# Get file extension using basename
extension="${input_file##*.}"

# Get filename without extension
filename=$(basename "$input_file" ".$extension")

# Get directory path
directory=$(dirname "$input_file")

# Construct output filename with direction
output_file="${directory}/${filename}--rot-${direction}.${extension}"
# Use ffprobe to get codec information
video_codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_file")
audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_file")

# FFmpeg command with transpose for 90-degree clockwise rotation
ffmpeg -i "$input_file" \
    -vf "transpose=$transpose_value" \
    -c:v "$video_codec" \
    -c:a "$audio_codec" \
    -q:v 2 \
    -map_metadata 0 \
    -map 0 \
    "$output_file"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Successfully created rotated video: $output_file"
else
    echo "Error occurred during conversion"
    exit 1
fi
