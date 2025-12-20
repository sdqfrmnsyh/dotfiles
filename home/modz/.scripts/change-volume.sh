#!/usr/bin/env sh

# Desc:   Audio-volume changer via `amixer`.
# Author: Harry Kurn <alternate-se7en@pm.me>
# URL:    https://github.com/owl4ce/dotfiles/tree/ng/.scripts/change-volume.sh

# SPDX-License-Identifier: ISC

# shellcheck disable=SC2016,SC2166

export LANG='POSIX'
exec >/dev/null 2>&1

[ -x "$(command -v amixer)" ]

case "${1}" in
    +) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master "${AUDIO_VOLUME_STEPS:-5}%+" on -q
    ;;
    -) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master "${AUDIO_VOLUME_STEPS:-5}%-" on -q
    ;;
    0) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master 1+ toggle -q
    ;;
esac

exit ${?}
