 echo "Ubuntu Touch Screen Recorder-- starting"

adb exec-out timeout 120 mirscreencast -m /run/mir_socket --stdout --cap-interval 2 -s 384 640 | mplayer -demuxer rawvideo -rawvideo w=384:h=640:format=rgba -
