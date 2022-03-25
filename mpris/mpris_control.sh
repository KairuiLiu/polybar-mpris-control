#!/bin/bash
# commands: mrpis_control --[cmd]
#   cmd: select     : show a player select menu and select a player as current player
#        title      : get song's meta info
#        playpause  : toggle play/pause
#        next       : switch to next music
#        previous   : switch to last music
#        icon       : get icon of players
#        process    : get process
#        vc         : volume control

PARENT_BAR_PID=$(pgrep -a "polybar" | cut -d" " -f1)
PLAYERS=($(playerctl -l 2>/dev/null))
FORMAT="'{{ title }} - {{ artist }}'"
FORMAT_PROCESS="'{{ duration(position)}}/{{duration(mpris:length) }}'"
PLAYER_STATUS=-1
CUR_PLAYER=$(cat ~/.config/polybar/.curplayer.log)
EXIT_CODE=$?

update_players() {
    PLAYERS=($(playerctl -l 2>/dev/null))
}

init_player() {
    update_players
    if [ ${#PLAYERS[*]} -eq 0 ]; then
        CUR_PLAYER=""
        echo ${CUR_PLAYER} >~/.config/polybar/.curplayer.log
        return 1
    else
        CUR_PLAYER=$PLAYERS
        echo ${CUR_PLAYER} >~/.config/polybar/.curplayer.log
    fi
    return 0
}

update_state() {
    playerctl --player=$CUR_PLAYER status 1>/dev/null 2>&1
    if [ $? -eq 1 ]; then
        init_player
    elif [ ${#CUR_PLAYER} -eq 0 ]; then
        init_player
    fi
    staue=$(playerctl --player=$CUR_PLAYER status 2>/dev/null)
    if [ ${#CUR_PLAYER} -eq 0 ]; then
        PLAYER_STATUS=-1
    elif [ "$staue" == "Stopped" ]; then
        PLAYER_STATUS=0
    else
        PLAYER_STATUS=1
    fi
}

get_title() {
    cmd="playerctl --player=${CUR_PLAYER} metadata --format $FORMAT 2>/dev/null"
    eval $cmd
}

toggle_play() {
    playerctl --player=${CUR_PLAYER} play-pause 2>/dev/null
}

to_next() {
    playerctl --player=${CUR_PLAYER} next 2>/dev/null
}

to_previous() {
    playerctl --player=${CUR_PLAYER} previous 2>/dev/null
}

to_volume() {
    playerctl --player=${CUR_PLAYER} volume $1 2>/dev/null
}

get_process() {
    cmd="playerctl --player=${CUR_PLAYER} metadata --format $FORMAT_PROCESS 2>/dev/null"
    proc=$(eval $cmd)
    if [ "$proc" = "0:00/" ]; then
        echo ""
    else
        echo "$proc"
    fi
}

show_menu_selector() {
    update_players
    options=""
    for i in "${PLAYERS[@]}"; do
        t=$(get_icon $i)
        options="${options}${t} ${i}*"
    done
    options="${options} Exit"
    menu="$(rofi -sep "*" -dmenu -i -p "Choose Player" -location 0 -hide-scrollbar -line-padding 4 -padding 20 -kb-row-select "Tab" -kb-row-tab "" <<<${options})"
    menu=${menu:2}
    if [ menu == "Exit" ]; then
        return
    elif [ ${#menu} -eq 0 ]; then
        return
    else
        CUR_PLAYER=$menu
        echo ${CUR_PLAYER} >~/.config/polybar/.curplayer.log
    fi
}

menu_icon() {
    get_icon $CUR_PLAYER
}

get_icon() {
    res=""
    case $1 in
    *chrom*)
        res=""
        ;;
    *firefox*)
        res=""
        ;;
    *spotify*)
        res=""
        ;;
    *vlc*)
        res="嗢"
        ;;
    esac
    echo $res
}

update_state
if [ "$1" == "--icon" ]; then
    menu_icon
elif [ "$1" == "--select" ]; then
    show_menu_selector
elif [ "$1" == "--title" ]; then
    if [ $PLAYER_STATUS -eq -1 ]; then
        echo "PLAYER NOT FOUND"
    elif [ $PLAYER_STATUS -eq 0 ]; then
        echo "NO MUSIC IS PLAYING"
    else
        get_title
    fi
elif [ "$1" == "--process" ]; then
    if [ $PLAYER_STATUS -eq 1 ]; then
        get_process
    else
        echo ""
    fi
elif [ "$1" == "--playpause" ]; then
    toggle_play
elif [ "$1" == "--next" ]; then
    to_next
elif [ "$1" == "--previous" ]; then
    to_previous
elif [ "$1" == "--vc" ]; then
    to_volume $2
fi
