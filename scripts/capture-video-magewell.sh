#!/usr/bin/env fish


set output_file (date +%Y-%m-%d-%H-%M-%S).mov

# Run ffmpeg with the following arguments for video capture
ffmpeg \
  # Set the thread queue size to 4096 to handle large bursts of input frames
  # Increase to 8192 if frame drops occur, decrease to 2048 to reduce memory usage
  -thread_queue_size 4096 \
  # Enable VAAPI hardware acceleration for decoding using AMD GPU
  # Requires libva and amdvlk drivers configured in NixOS
  -hwaccel vaapi \
  # Specify the VAAPI device for AMD GPU
  # Ensure /dev/dri/renderD128 exists; check with `ls /dev/dri`
  -hwaccel_device /dev/dri/renderD128 \
  # Set input format to Video4Linux2 (V4L2) for Magewell capture card
  -f v4l2 \
  # Specify YUYV 4:2:2 pixel format, matching Magewell output
  # Verify with `v4l2-ctl -d /dev/video3 --all`
  -input_format yuyv422 \
  # Set frame rate to 25 fps, matching Magewell's 25.002 fps (PAL)
  # Try 25.002 if tearing or stuttering occurs
  -framerate 25 \
  # Set input resolution to 1920x1080
  # Adjust to 1280x720 if file size or performance is a concern
  -video_size 1920x1080 \
  # Set real-time buffer size to 512 MB to prevent input frame drops
  # Increase to 1G if drops persist, decrease to 256M if memory usage is high
  -rtbufsize 512M \
  # Set probe size to 64 MB for stable input detection
  # Increase to 128M if input detection fails, decrease to 32M for faster startup
  -probesize 64M \
  # Specify input device as /dev/video3 (Magewell Pro Capture)
  # Verify with `v4l2-ctl --list-devices`
  -i /dev/video3 \
  # Apply video filters: rotate 90 degrees clockwise and convert to YUV 4:2:0
  # transpose=1 is CPU-based; format=yuv420p ensures H.264 compatibility
  -vf "transpose=1,format=yuv420p" \
  # Use libx264 codec for near-lossless H.264 encoding
  -c:v libx264 \
  # Set CRF to 10 for near-lossless quality with smaller file size
  # Lower to 0 for true lossless (larger files), increase to 18 for smaller files
  -crf 10 \
  # Use ultrafast preset for minimal encoding latency
  # Try 'veryfast' for better compression if CPU can handle it
  -preset ultrafast \
  # Use PCM 16-bit little-endian audio for lossless audio
  # Remove with '-an' if audio is not needed
  -c:a pcm_s16le \
  # Use 8 threads for CPU-based transpose and encoding
  # Adjust to match your CPU core count (e.g., 12 for Ryzen 9)
  -threads 8 \
  # Output to .mov container for editing compatibility
  # Use .mkv with '-f matroska' if .mov is incompatible
  -f mov \
  # Output file name
  # Change to desired path/filename
  $output_file
