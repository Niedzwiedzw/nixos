#!/usr/bin/env bash

set -e
# Check if input file is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 input_video"
    exit 1
fi

# Input file
input="$1"
# factor
factor="$2"

# Check if file exists
if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found"
    exit 1
fi

# Get file details
filename=$(basename "$input")
extension="${filename##*.}"
name="${filename%.*}"
directory=$(dirname "$input")

# Output file
output="${directory}/${name}--half.${extension}"

# Get current resolution
resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$input")
width=$(echo $resolution | cut -d'x' -f1)
height=$(echo $resolution | cut -d'x' -f2)

echo "input size is ${width}x${height}";


# Calculate half resolution
new_width=$((width / factor))
new_height=$((height / factor))

# Get current bitrate
bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$input")
echo "input bitrate is ${bitrate}";
# Calculate half bitrate
new_bitrate=$((bitrate / factor))

# Run ffmpeg command
ffmpeg -i "$input" \
    -vf scale=$new_width:$new_height \
    -b:v ${new_bitrate} \
    -c:a copy \
    -y "$output"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Successfully created $output"
else
    echo "Error during conversion"
    exit 1
fi
