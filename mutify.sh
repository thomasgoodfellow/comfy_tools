#!/bin/bash

# set commercial mute, so we do not neet to listen to them

echo "----------------------------------------------------------"
echo ""
echo "   Mute spotify commercial"
echo ""
echo "----------------------------------------------------------"


# WMTITLE="Spotify Free - Linux Preview"
WMTITLE="Bingo Players - Out Of My Mind - Dada Life Remix"


xprop -spy -name "$WMTITLE" WM_ICON_NAME |
    while read -r XPROPOUTPUT; do
        echo "!! $XPROPOUTPUT !!"
        XPROP_TRACKDATA="$(echo "$XPROPOUTPUT" | awk '/WM_ICON_NAME/ {split($0, A, "\\(COMPOUND_TEXT|STRING\\) = "); print substr(A[2], 2, length(A[2]) - 2) }')"
        DBUS_TRACKDATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
        org.freedesktop.MediaPlayer2.GetMetadata | grep xesam:title -A 1 | grep variant | awk '{ split($0, A, "\\s*variant\\s+string\\s*"); print A[2] }' )"

        # show something
        echo "XPROP:      $XPROP_TRACKDATA"
        echo "DBUS:       $DBUS_TRACKDATA"

        # presume first song not commerical, also check whether just paused
        if [ "$OLD_XPROP" = "" ]
        then
            echo "commercial: we don't know yet"
        elif [ "$XPROP_TRACKDATA" = "Spotify" ]
        then
            echo "commercial: - paused"
            if [ "$IS_COMMERCIAL" = "0" ] ; then OLD_DBUS=0 ; fi
            continue
        elif [ "$XPROP_TRACKDATA" = "$OLD_XPROP" ]
        then
            continue
        else  
            # check if old DBUS is the same as the new, if true then we have a commercial, so mute
            if [ "$OLD_DBUS" = "$DBUS_TRACKDATA" ]
            then
                echo "commercial: yes"
                IS_COMMERCIAL=1
                amixer -D pulse set Master mute >> /dev/null
            else
                echo "commercial: no"
                IS_COMMERCIAL=0
                if [ "$OLD_COMMERCIAL" = "1" ] ; then sleep 1.5 ; fi
                amixer -D pulse set Master unmute >> /dev/null
            fi
        fi
        echo "----------------------------------------------------------"
        OLD_XPROP=$XPROP_TRACKDATA
        OLD_DBUS=$DBUS_TRACKDATA
        OLD_COMMERCIAL=$IS_COMMERCIAL

done

exit 0
