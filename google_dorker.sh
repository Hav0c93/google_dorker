#!/usr/bin/env bash
#
# Google Dork Launcher
# A clean, beginner-friendly, open-source tool to launch Google Dorks from the terminal.
# Author: Your Name
# License: MIT
#

# -----------------------------
# ASCII Banner
# -----------------------------
banner() {
    echo -e "
  ____                 _       ____             _    
 / ___| ___   ___   __| | ___|  _ \  ___   ___| | __
| |  _ / _ \ / _ \ / _  |/ _ \ | | |/ _ \ / __| |/ /
| |_| | (_) | (_) | (_| |  __/ |_| | (_) | (__|   < 
 \____|\___/ \___/ \__,_|\___|____/ \___/ \___|_|\_\\
              Google Dork Launcher v1.3
    "
}

# -----------------------------
# Colors
# -----------------------------
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

VERSION="1.3"

# -----------------------------
# URL Encoder
# -----------------------------
urlencode() {
    local LANG=C
    local encoded=""
    local c
    for ((i=0; i<${#1}; i++)); do
        c=${1:$i:1}
        case $c in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            *) encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    printf '%s' "$encoded"
}

# -----------------------------
# HELP PAGE
# -----------------------------
show_help() {
    banner
    echo -e "${CYAN}Usage:${RESET}"
    echo "  google-dork-launcher.sh [OPTIONS]"
    echo ""
    echo -e "${CYAN}Options:${RESET}"
    echo -e "  ${YELLOW}-q, --query \"<dork>\"${RESET}   Launch a Google Dork directly"
    echo -e "  ${YELLOW}--ghdb${RESET}                  Open Google Hacking Database"
    echo -e "  ${YELLOW}-h, --help${RESET}             Show this help page"
    echo -e "  ${YELLOW}-v, --version${RESET}          Show version information"
    echo ""
    echo -e "${CYAN}Examples:${RESET}"
    echo "  ./google-dork-launcher.sh --query \"site:edu filetype:pdf\""
    echo "  ./google-dork-launcher.sh --ghdb"
    echo ""
}

# -----------------------------
# Version
# -----------------------------
show_version() {
    echo "Google Dork Launcher v$VERSION"
}

# -----------------------------
# GHDB Shortcut
# -----------------------------
open_ghdb() {
    echo -e "${GREEN}[OK] Opening Google Hacking Database...${RESET}"
    xdg-open "https://www.exploit-db.com/google-hacking-database" >/dev/null 2>&1 &
}

# -----------------------------
# PRESET DORK CATEGORIES
# -----------------------------
show_categories() {
    echo -e "${CYAN}Choose a category:${RESET}"
    echo ""
    echo "  1) File Types"
    echo "  2) Login Pages"
    echo "  3) Index Pages"
    echo "  4) Public Documents"
    echo "  5) Back to Menu"
    echo ""
}

choose_dork() {
    read -p "Select: " opt
    case $opt in
        1)
            echo -e "${GREEN}File Type Dorks:${RESET}"
            echo "1) filetype:pdf \"user guide\""
            echo "2) filetype:txt \"configuration\""
            echo "3) filetype:doc \"manual\""
            read -p "Choose: " f
            case $f in
                1) DORK_QUERY='filetype:pdf "user guide"' ;;
                2) DORK_QUERY='filetype:txt "configuration"' ;;
                3) DORK_QUERY='filetype:doc "manual"' ;;
            esac ;;
        2)
            echo -e "${GREEN}Login Page Dorks:${RESET}"
            echo "1) intitle:\"login\" \"username\""
            echo "2) inurl:auth intitle:login"
            echo "3) inurl:login.php"
            read -p "Choose: " f
            case $f in
                1) DORK_QUERY='intitle:"login" "username"' ;;
                2) DORK_QUERY='inurl:auth intitle:login' ;;
                3) DORK_QUERY='inurl:login.php' ;;
            esac ;;
        3)
            echo -e "${GREEN}Index Pages:${RESET}"
            echo "1) intitle:\"index of\""
            echo "2) intitle:\"index of\" backup"
            echo "3) intitle:\"index of\" /files"
            read -p "Choose: " f
            case $f in
                1) DORK_QUERY='intitle:"index of"' ;;
                2) DORK_QUERY='intitle:"index of" backup' ;;
                3) DORK_QUERY='intitle:"index of" /files' ;;
            esac ;;
        4)
            echo -e "${GREEN}Public Documents:${RESET}"
            echo "1) site:gov filetype:pdf"
            echo "2) site:edu filetype:pdf \"report\""
            echo "3) site:org \"annual report\" filetype:pdf"
            read -p "Choose: " f
            case $f in
                1) DORK_QUERY='site:gov filetype:pdf' ;;
                2) DORK_QUERY='site:edu filetype:pdf "report"' ;;
                3) DORK_QUERY='site:org "annual report" filetype:pdf' ;;
            esac ;;
        5)
            return ;;
        *)
            echo -e "${RED}Invalid option.${RESET}" ;;
    esac

    launch_dork
}

# -----------------------------
# QUERY LAUNCH
# -----------------------------
launch_dork() {
    if [[ -z "$DORK_QUERY" ]]; then
        echo -e "${RED}No query found.${RESET}"
        return
    fi

    ENCODED_QUERY=$(urlencode "$DORK_QUERY")
    GOOGLE_URL="https://www.google.com/search?q=$ENCODED_QUERY"

    echo -e "${GREEN}[OK] Opening:${RESET} $GOOGLE_URL"
    xdg-open "$GOOGLE_URL" >/dev/null 2>&1 &
}

# -----------------------------
# MENU MODE
# -----------------------------
menu() {
    banner
    echo -e "${CYAN}1) Enter Custom Query${RESET}"
    echo -e "${CYAN}2) Use Ready-Made Dorks${RESET}"
    echo -e "${CYAN}3) Open Google Hacking Database (GHDB)${RESET}"
    echo -e "${CYAN}4) Exit${RESET}"
}

# -----------------------------
# FLAG PARSING
# -----------------------------
if [[ $# -gt 0 ]]; then
    case "$1" in
        -h|--help)
            show_help
            exit 0 ;;
        -v|--version)
            show_version
            exit 0 ;;
        -q|--query)
            shift
            DORK_QUERY="$*"
            launch_dork
            exit 0 ;;
        --ghdb)
            open_ghdb
            exit 0 ;;
        *)
            echo -e "${RED}Unknown option:${RESET} $1"
            echo "Use --help for usage."
            exit 1 ;;
    esac
fi

# -----------------------------
# MAIN LOOP
# -----------------------------
while true; do
    menu
    read -p "Select: " choice
    case $choice in
        1)
            echo -e "${YELLOW}Enter your Google Dork query:${RESET}"
            read -r DORK_QUERY
            launch_dork ;;
        2)
            show_categories
            choose_dork ;;
        3)
            open_ghdb ;;
        4)
            exit 0 ;;
        *)
            echo -e "${RED}Invalid option.${RESET}" ;;
    esac
done
