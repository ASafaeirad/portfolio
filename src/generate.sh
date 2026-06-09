#!/usr/bin/env bash

CLEAR=$(tput clear)
MUTED=$(tput setaf 244)
BOLD=$(tput bold)
RESET=$(tput sgr0)
SECONDARY=$(tput setaf 7)
PRIMARY=$(tput setaf 11)
ACCENT=$(tput setaf 6)
ITALIC=$(tput sitm)

pad_lines() {
    local input="$1"
    local width="$2"
    local line

    while IFS= read -r line || [[ -n "$line" ]]; do
        printf '%*s' "$width" ''
        printf "%s\n" "$line"
    done <<< "$input"
}

mapfile -t DEER_LINES < src/ascii-art/deer.txt
mapfile -t MAN < src/ascii-art/man.txt
DEER_HEIGHT=${#DEER_LINES[@]}
DEER_WIDTH=${#DEER_LINES[1]}
MAN_OFFSET=15
MAN_HEIGHT=${#MAN[@]}
FILE_LINES=$((MAN_HEIGHT + MAN_OFFSET))
GAP=-10

ART=$(for ((i=0; i<FILE_LINES; i++)); do
    if [[ $i -le DEER_HEIGHT ]]; then
        printf "%s" "${PRIMARY}${DEER_LINES[i]}${RESET}"
    fi
    if [[ $i -ge $MAN_OFFSET ]]; then
        MAN_LINE=${MAN[i - MAN_OFFSET]}
        MAN_LINE_WIDTH=$GAP
        if [[ $i -ge $DEER_HEIGHT ]]; then
          MAN_LINE_WIDTH=$MAN_LINE_WIDTH+${#MAN_LINE}+20
        fi
        printf "%*s\n" $((DEER_WIDTH+MAN_LINE_WIDTH)) "${ACCENT}${MAN_LINE}${RESET}"
    else
        printf "\n"
    fi
done)

BOX=$(cat <<EOF

                          Hi 👋,  name is ${BOLD}${PRIMARY}Alireza.${RESET}

   ${ITALIC}   a software engineer with +15 years of professional experience${RESET}
   ${ITALIC}I'm curious and passionate about learning, and crafting new things.${RESET}

   ${BOLD}Website${RESET}                                       ${MUTED}https://${ACCENT}asafaeirad.com${RESET}
   ${BOLD}Email${RESET}                                    ${MUTED}alireza.safaierad${RESET}${ACCENT}@gmail.com${RESET}
   ${BOLD}Github${RESET}                                 ${MUTED}https://github.com/${ACCENT}ASafaeirad${RESET}
   ${BOLD}Linkedin${RESET}                      ${MUTED}https://www.linkedin.com/in/${ACCENT}ASafaeirad${RESET}

EOF
)

ART=$(pad_lines "$ART" 20)
BOX=$(pad_lines "$BOX" 16)
# echo "$(pad_lines "TEST" 10)"

echo "$CLEAR" > public/index.txt
echo "$ART" >> public/index.txt
echo
echo "$BOX" >> public/index.txt
