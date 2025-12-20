#!/usr/bin/env sh

# Desc:   Display brightness changer via `brightnessctl`.
# Author: Harry Kurn <alternate-se7en@pm.me>
# URL:    https://github.com/owl4ce/dotfiles/tree/ng/.scripts/change-brightness.sh

# SPDX-License-Identifier: ISC

# shellcheck disable=SC2016

export LANG='POSIX'
exec >/dev/null 2>&1

[ -x "$(command -v brightnessctl)" ]

case "${1}" in
    +) brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} set "${BRIGHTNESS_STEPS:-5}%+" -q
    ;;
    -) brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} set "${BRIGHTNESS_STEPS:-5}%-" -q
    ;;
esac

exit ${?}
