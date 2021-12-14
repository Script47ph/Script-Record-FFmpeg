#!/bin/bash

ffmpeg -video_size 1366x768 -framerate 60 -f x11grab -i :0.0 -c:v h264_nvenc -qp 0 -preset p7 -profile:v high444p -pixel_format yuv444p
# Credit
sleep 1
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
echo " Script to Record Desktop With FFmpeg                            ";
echo " This script created by Script47                                 ";
echo " My SNS : https://fb.me/script47                                 ";
echo " Version : 0.1 -- Beta Testing                                   ";
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
sleep 1
options;