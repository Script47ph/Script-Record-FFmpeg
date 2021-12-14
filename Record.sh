#!/bin/bash

#ffmpeg -video_size 1366x768 -framerate 60 -f x11grab -i :0.0 -c:v h264_nvenc -qp 0 -preset p7 -profile:v high444p -pixel_format yuv444p

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}
#FFmpeg Command to Record
ffmpeg_record () {
    if [[ ${optionscodecs[$choicecodecs]} == "hevc_nvenc" ]] || [[ ${optionscodecs[$choicecodecs]} == "h264_nvenc" ]];then
        echo "FFMpeg Starting. Please wait..."
        mkdir -p "$HOME/Videos/FFmpeg Record/"
        sleep 1
        ffmpeg -framerate ${optionsfps[$choicefps]} -f x11grab -i :0.0 -c:v ${optionscodecs[$choicecodecs]} -qp 0 -preset p7 -profile:v ${optionsprofiles[$choiceprofiles]} -pix_fmt ${optionspixfmt[$choicepixfmt]} "$HOME/Videos/FFmpeg Record/Record_`date +%d-%m-%Y_%T`${optionsformats[$choiceformats]}" -hide_banner
    elif [[ ${optionscodecs[$choicecodecs]} == "libx265" ]] || [[ ${optionscodecs[$choicecodecs]} == "libx264" ]];then
        echo "FFMpeg Starting. Please wait..."
        mkdir -p "$HOME/Videos/FFmpeg Record/"
        sleep 1
        ffmpeg -framerate ${optionsfps[$choicefps]} -f x11grab -i :0.0 -c:v ${optionscodecs[$choicecodecs]} -crf 0 -preset slow -profile:v ${optionsprofiles[$choiceprofiles]} -pix_fmt ${optionspixfmt[$choicepixfmt]} "$HOME/Videos/FFmpeg Record/Record_`date +%d-%m-%Y_%T`${optionsformats[$choiceformats]}" -hide_banner 
    fi
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
clear
# Savepoint;

# Options Format
echo "Select your output format"
echo "Select one option using up/down keys and enter to confirm:"
echo
optionsformats=(".mp4" ".mkv" ".webm")
select_option "${optionsformats[@]}"
choiceformats=$?
# echo "Choosen index = $choice"
# echo "        value = ${optionsformats[$choiceformats]}"
clear

# Options Codec
echo "Select your codec to record"
echo "Select one option using up/down keys and enter to confirm:"
echo
optionscodecs=("libx264" "libx265" "h264_nvenc" "hevc_nvenc")
select_option "${optionscodecs[@]}"
choicecodecs=$?
clear

# Options Profile
if [[ ${optionscodecs[$choicecodecs]} == "libx264" ]] || [[ ${optionscodecs[$choicecodecs]} == "h264_nvenc" ]];then
    echo "Select your codec profile"
    echo "Select one option using up/down keys and enter to confirm:"
    echo
    optionsprofiles=("baseline" "main" "high" "high444p")
    select_option "${optionsprofiles[@]}"
    choiceprofiles=$?
    clear
elif [[ ${optionscodecs[$choicecodecs]} == "libx265" ]] || [[ ${optionscodecs[$choicecodecs]} == "hevc_nvenc" ]];then
    echo "Select your codec profile"
    echo "Select one option using up/down keys and enter to confirm:"
    echo
    optionsprofiles=("main" "main10")
    select_option "${optionsprofiles[@]}"
    choiceprofiles=$?
    clear
fi

# Options Pixel Format
echo "Select your pixel format"
echo "Select one option using up/down keys and enter to confirm:"
echo
optionspixfmt=("yuv420p" "yuv444p" "yuv444p16le")
select_option "${optionspixfmt[@]}"
choicepixfmt=$?
clear

# Options Framerate
echo "Select your framerate"
echo "Select one option using up/down keys and enter to confirm:"
echo
optionsfps=("24" "30" "60")
select_option "${optionsfps[@]}"
choicefps=$?
clear
ffmpeg_record