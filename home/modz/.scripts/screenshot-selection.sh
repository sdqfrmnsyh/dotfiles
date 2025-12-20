#!/usr/bin/env sh

# Desc:   Take screenshot by select the visible window or draw. (MODIFIED - NO FRAMING/BORDER)
# Author: Harry Kurn <alternate-se7en@pm.me> (Modified by Gemini)

# SPDX-License-Identifier: ISC

# shellcheck disable=SC2016,SC2166

export LANG='POSIX'

# --- CONFIGURASI HARDCODED ---
# Direktori penyimpanan hasil tangkapan layar
SS_SVDIR="${HOME}/Pictures"
# Direktori sementara (memakai /tmp)
TMP_DIR="/tmp/screenshot-selection"
# Apakah menyalin ke clipboard (yes/no)
SS_CP2CLP='yes'
# Apakah menyimpan ke disk (yes/no)
SS_SAVE='yes'
# Gunakan fitur frame dan bayangan ImageMagick? (yes/no)
SS_USE_FRAME='no' # <--- PERUBAHAN KRITIS DI SINI
# Warna frame: 'auto' atau kode hex, default ke warna netral jika 'auto' gagal
SS_FRAME_COLOR='auto'
# Kualitas JPEG/PNG (85 adalah default)
SS_QUALITY='100'
# End of Hardcoded Config

# --- Dependency Check ---
# HANYA scrot dan xclip yang wajib jika framing dimatikan
[ -x "$(command -v scrot)" ] || { echo "Error: Install 'scrot'!" >&2; exit 1; }
# ImageMagick tidak lagi dicek karena SS_USE_FRAME='no'

# --- Main Logic ---
{
    # Buat direktori sementara jika belum ada
    [ ! -d "$TMP_DIR" ] && mkdir -p "$TMP_DIR"

    # Bersihkan file lama, jalankan di background (&)
    rm -f "$TMP_DIR"/*_scrot*.* &

    # Add 210ms delay to trick compositor fade animation.
    sleep .21s

    [ "$SS_POINTER" != 'yes' ] || ARGS='-p' 

    # Ambil screenshot. Jika gagal, skrip langsung keluar.
    scrot ${ARGS} -b \
                  -e "mv -f \$f \"${TMP_DIR}/\"" \
                  -f \
                  -i \
                  -l style=dash,width=3,color=#2be491 \
                  -s \
                  -z \
    || exit 1 # Keluar jika pembatalan atau error scrot

    wait # Tunggu rm -f selesai

    # Temukan nama file yang baru dibuat
    for CURRENT in "$TMP_DIR"/*_scrot*.*; do
        CURRENT="${CURRENT##*/}"
        break
    done

    # --- Pemrosesan ImageMagick ---
    # BLOK INI SEKARANG DILEWATI KARENA SS_USE_FRAME='no'
    if [ "$SS_USE_FRAME" = 'yes' ]; then 
        # Seluruh kode pemrosesan ImageMagick ada di sini, 
        # dan tidak akan dieksekusi.
        # ... (Kode ImageMagick yang kompleks) ...
        # ...
        exit 1 # Baris ini tidak akan pernah tercapai
    fi

    # --- Menyalin dan Menyimpan ---

    # Salin ke Clipboard
    if [ "$SS_CP2CLP" = 'yes' ] && [ -x "$(command -v xclip)" ]; then
        xclip -selection clipboard -target image/png -i "${TMP_DIR}/${CURRENT}"
    fi

    # Simpan File
    if [ "$SS_SAVE" = 'yes' ]; then
        # Simpan di SS_SVDIR/Screenshots
        TARGET_DIR="${SS_SVDIR}/Screenshots"
        [ -d "${TARGET_DIR}" ] || mkdir -p "${TARGET_DIR}"
        
        # Pindahkan file asli yang BUKAN hasil ImageMagick
        mv -f "${TMP_DIR}/${CURRENT}" "${TARGET_DIR}/" 
    else
        # Hapus file sementara jika hanya disalin ke clipboard
        rm -f "${TMP_DIR}/${CURRENT}"
    fi
} &

exit ${?}
