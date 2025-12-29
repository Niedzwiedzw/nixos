#!/usr/bin/env bash

# Check if a file path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_video_path>"
    exit 1
fi

# Input file path
input="$1"

# Check if input file exists
if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found"
    exit 1
fi

# Extract directory, filename, and extension
dir=$(dirname "$input")
filename=$(basename "$input")
name="${filename%.*}"  # Remove extension
ext="${filename##*.}"  # Get extension

# Output file path with --small postfix
output="$dir/${name}--small.$ext"

# Get video duration in seconds (using ffprobe)
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")
duration=${duration%.*}  # Remove decimal part

# Calculate target video bitrate for ~24MB (192 Mb total)
# 24MB = 192 Mb, so bitrate (kbps) = (192 * 1000) / duration
target_bitrate=$(( (192 * 100) / duration ))
audio_bitrate=96  # Set audio bitrate to 96 kbps
video_bitrate=$(( target_bitrate - audio_bitrate ))  # Video gets the rest

# Ensure video bitrate doesn't go negative or too low
if [ $video_bitrate -lt 500 ]; then
    video_bitrate=500  # Minimum reasonable bitrate
fi

# FFmpeg command to reduce size
ffmpeg -i "$input" -b:v "${video_bitrate}k" -b:a "${audio_bitrate}k" -vf scale=320:240 -r 15 -c:v libx264 -c:a aac "$output"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Output saved as: $output"
    # Get file size in MB
    size=$(du -m "$output" | cut -f1)
    echo "File size: ${size}MB"
    if [ $size -gt 24 ]; then
        echo "Warning: File size exceeds 24MB. Consider lowering bitrate or resolution."
    fi
else
    echo "Error: FFmpeg conversion failed"
    exit 1
fi
