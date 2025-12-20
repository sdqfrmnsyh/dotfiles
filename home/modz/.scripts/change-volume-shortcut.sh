#!/usr/bin/env sh

# Desc:    Audio-volume changer via `amixer`.
# Author: Harry Kurn <alternate-se7en@pm.me>
# URL:     https://github.com/owl4ce/dotfiles/tree/ng/.scripts/change-volume.sh

# SPDX-License-Identifier: ISC

# shellcheck disable=SC2016,SC2166

export LANG='POSIX'
# exec >/dev/null 2>&1  <-- Hapus atau komen baris ini sementara saat pengujian

[ -x "$(command -v amixer)" ] || exit 1 # Keluar jika amixer tidak ada

#############################################
# DEBOUNCE / PENCEGAHAN DOUBLE-CLICK
#############################################

# 1. Definisikan file temporer untuk menyimpan waktu klik terakhir
#    Gunakan $XDG_RUNTIME_DIR jika tersedia, atau /tmp sebagai fallback.
#    Pastikan nama file unik untuk skrip ini.
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/change-volume.lock"

# 2. Definisikan interval waktu minimum antar klik (dalam detik)
#    0.2 detik (200 milidetik) biasanya cukup untuk debounce.
DEBOUNCE_TIME=0.2

# 3. Dapatkan waktu saat ini dalam detik dan nanodetik
CURRENT_TIME=$(date +%s.%N)

# 4. Cek apakah file lock ada dan baca waktu terakhir
if [ -f "$LOCK_FILE" ]; then
    LAST_TIME=$(cat "$LOCK_FILE")
    
    # Hitung selisih waktu (hanya berfungsi di shell yang mendukung float, seperti bash)
    # Karena Anda menggunakan /usr/bin/env sh (yang seringkali symlink ke dash/bash), 
    # kita akan menggunakan awk untuk perhitungan floating point agar kompatibel.
    TIME_DIFF=$(echo "$CURRENT_TIME - $LAST_TIME" | awk '{print $1 - $2}')
    
    # Periksa apakah selisih kurang dari DEBOUNCE_TIME
    if [ $(echo "$TIME_DIFF < $DEBOUNCE_TIME" | bc -l) -eq 1 ]; then
        # Jika waktu terlalu cepat, anggap sebagai double-click yang tidak disengaja, dan keluar
        # echo "Debounce: Klik terlalu cepat ($TIME_DIFF detik). Diabaikan." >&2 # Baris debugging
        exit 0
    fi
fi

# 5. Simpan waktu klik saat ini ke file lock
echo "$CURRENT_TIME" > "$LOCK_FILE"

#############################################
# AKSI SKRIP UTAMA
#############################################

# Kembalikan baris ini setelah pengujian berhasil:
exec >/dev/null 2>&1

case "${1}" in
    +) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master "${AUDIO_VOLUME_STEPS:-5}%+" on -q
    ;;
    -) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master "${AUDIO_VOLUME_STEPS:-5}%-" on -q
    ;;
    0) amixer ${AUDIO_DEVICE:+-D "$AUDIO_DEVICE"} sset Master 1+ toggle -q
    ;;
esac

exit ${?}
