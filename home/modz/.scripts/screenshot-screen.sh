#!/usr/bin/env sh

# Desc:   Take screenshot of all available screens. (MODIFIED: Removed dunstify and .joyfuld)
# Author: Harry Kurn <alternate-se7en@pm.me> (Modified by AI)
# URL:    https://github.com/owl4ce/dotfiles/tree/ng/.scripts/screenshot-screen.sh

# SPDX-License-Identifier: ISC

# shellcheck disable=SC2016,SC2166

export LANG='POSIX'

# --- DEFAULTS HARDCODED (Menggantikan konfigurasi .joyfuld) ---
SS_CP2CLP='yes'       # yes/no: Apakah akan menyalin ke clipboard?
SS_SAVE='yes'         # yes/no: Apakah akan menyimpan file?
SS_SVDIR="$HOME/Pictures" # Direktori penyimpanan (misal: ~/Pictures/Screenshots)
SS_QUALITY='75'       # Kualitas JPEG (0-100)
SS_POINTER='no'       # yes/no: Sertakan pointer mouse?
# ----------------------------------------------------------------------


# --- Pengecekan Ketersediaan scrot ---
if ! [ -x "$(command -v scrot)" ]; then
    echo "ERROR: Install 'scrot'!"
    exit 1
fi

{
    # Tambahkan penundaan jika ada argumen
    [ -z "${1}" ] || sleep .21s

    CLIP=''
    STS2='' # Status 2 untuk clipboard
    
    # Logic untuk menentukan apakah akan copy ke clipboard
    while :; do
        if [ "$SS_CP2CLP" = 'yes' -a -x "$(command -v xclip)" ]; then
            CLIP='xclip -selection clipboard -target image/png -i $f;'
            STS2=' | COPIED to clipboard'
            break
        elif [ "$SS_SAVE" != 'yes' ]; then
            SS_CP2CLP='yes'
        else
            break
        fi
    done

    # Logic untuk menentukan apakah akan save ke file
    if [ "$SS_SAVE" = 'yes' ]; then
        [ -d "${SS_SVDIR}/Screenshots" ] || mkdir -p "${SS_SVDIR}/Screenshots"
        EXEC="${CLIP} mv -f \$f \"${SS_SVDIR}/Screenshots/\""
        STS1="Saved to: ${SS_SVDIR}/Screenshots"
    else
        EXEC="${CLIP} rm -f \$f"
        STS1='(Temporary file removed)'
    fi
    
    # Atur argumen pointer
    [ "$SS_POINTER" != 'yes' ] || ARGS='-p'

    # --- Eksekusi Scrot ---
    scrot ${ARGS} -e "$EXEC" \
                  -q "${SS_QUALITY}" \
                  -z \
    
    # Cek status keluar scrot
    if [ $? -ne 0 ]; then
        echo "ERROR: Screenshot failed!"
        exit 1
    fi

    # --- Feedback Terminal ---
    echo "SUCCESS: Screenshot taken."
    echo "${STS1}${STS2}"
} &

exit ${?}
