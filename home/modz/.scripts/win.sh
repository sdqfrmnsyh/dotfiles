#!/bin/bash

# jgmenu_run memiliki logika built-in untuk mengontrol instance
if pgrep -x "jgmenu" > /dev/null; then
    pkill -x "jgmenu"
else
    jgmenu_run
fi
