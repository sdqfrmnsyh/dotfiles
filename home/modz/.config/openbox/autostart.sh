picom&
plank&
~/.fehbg&
unclutter -idle 1&
xidlehook \
        --detect-sleep \
        --not-when-fullscreen \
        --timer 3600 \
          'dm-tool lock' \
          '' \
        &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xfce4-power-manager --daemon
powerprofilesctl set power-saver
