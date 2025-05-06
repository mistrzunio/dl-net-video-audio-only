#!/bin/bash

# check for url as command parameter: 
if [ -z "$1" ]; then 
  echo "Usage: $0 VIDEO_URL"
  exit 1
fi

# attempt to download using yt-dlp
opus=$(yt-dlp -x $1 | grep ExtractAudio | cut -d ':' -f 2-) 

# Check if the download was successful (variable not empty)
if [ -z "$opus" ]; then
  echo "Error: yt-dlp did not produce a filename."
  exit 1
fi

trimd_opus=$(printf '%s' "$opus" | awk '{ sub(/^[[:space:]]+/, ""); sub(/[[:space:]]+$/, ""); print }')

echo "Downloaded file likely named: $trimd_opus"

# Ensure the file actually exists before converting
if [ ! -f "$trimd_opus" ]; then
    echo "Error: Downloaded file '$trimd_opus' not found!"
    # Attempt to find the actual downloaded file if the captured name is wrong
    # This is a guess - finding the *actual* downloaded file reliably
    # without knowing the output template is hard.
    echo "Check the directory for the actual downloaded audio file."
    exit 1
fi

# Quote the variable in ffmpeg command
echo "Converting '$trimd_opus' to output.mp3..."
ffmpeg -i "$trimd_opus" output.mp3

echo "Conversion complete: output.mp3"
echo "Removing opus file: $trimd_opus"
rm "$trimd_opus" 

#opus = $(yt-dlp -x "https://www.youtube.com/shorts/wazat1asxVM")
#ffmpeg -i $opus output.mp3
