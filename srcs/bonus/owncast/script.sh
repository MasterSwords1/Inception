#!/bin/bash

PLAYLIST_URL="https://www.youtube.com/playlist?list=PLke4g-fS3LOaaUgmHkFiQ8K9Bww8dfKTf"

cd /videos
# If directory is empty → run yt-dlp
if [ -z "$(ls -A /videos)" ]; then
    /yt-dlp_linux \
      -f "bv*[ext=mp4][height<=1080]+ba*[ext=m4a]/b[ext=mp4][height<=1080]" \
      --merge-output-format mp4 \
      -o "%(title)s.%(ext)s" \
      "$PLAYLIST_URL"

fi
cd -
./stream.sh &

./owncast -adminpassword secret_pass -enableVerboseLogging -webserverip 0.0.0.0 -webserverport 8000
