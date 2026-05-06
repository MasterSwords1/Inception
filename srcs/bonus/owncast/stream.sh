#!/bin/bash

VIDEO_DIR="/videos"
RTMP_URL="rtmp://localhost:1935/live/stream"

while true; do
  shopt -s nullglob
  files=("$VIDEO_DIR"/*.mp4)

  if [ ${#files[@]} -eq 0 ]; then
    echo "No MP4 files found in $VIDEO_DIR. Waiting..."
    sleep 5
    continue
  fi

  for file in "${files[@]}"; do
    echo "Streaming $file..."

    ffmpeg -re -i "$file" \
      -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
      -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k \
      -pix_fmt yuv420p -g 50 \
      -c:a aac -b:a 128k -ar 44100 \
      -f flv "$RTMP_URL"
  done
done
