#!/bin/bash

#ffmpeg -video_size 1366x768 -framerate 60 -f x11grab -i :0.0 -c:v h264_nvenc -qp 0 -preset p7 -profile:v high444p -pixel_format yuv444p

# Choose Save Directory
Savepoint () {
    echo "Choose your directory to save file"
    sleep 1
    directory=$(zenity --file-selection --title='Select a directory to save file' --directory);
    sleep 1
    echo "Your directory on ($directory) has been choosed."
    sleep 3
    exit
    #options;
}
# Credit
sleep 1
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
echo " Script to Record Desktop With FFmpeg                            ";
echo " This script created by Script47                                 ";
echo " My SNS : https://fb.me/script47                                 ";
echo " Version : 1.0                                                   ";
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
sleep 1
Savepoint;