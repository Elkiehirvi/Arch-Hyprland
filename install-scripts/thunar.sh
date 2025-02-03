#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Thunar #

if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

thunar=(
  thunar 
  thunar-volman 
  tumbler
  ffmpegthumbnailer 
  thunar-archive-plugin
  xarchiver
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_thunar.log"

# Thunar
printf "${NOTE} Installing ${SKY_BLUE}Thunar${RESET} Packages...\n\n"  
  for THUNAR in "${thunar[@]}"; do
    install_package "$THUNAR" "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $THUNAR Package installation failed, Please check the installation logs"; exit 1; }
  done

printf "\n%.0s" {1..2}

# confirm if wanted to set as default
while true; do
  read -n 1 -r -p "${CAT} set ${MAGENTA}Thunar${RESET} as the default file manager? (y/n)" thundefault
  case $thundefault in
    [Yy]) 
      xdg-mime default thunar.desktop inode/directory
      xdg-mime default thunar.desktop application/x-wayland-gnome-saved-search
      echo "${OK} Thunar has been set as the default file manager." | tee -a "$LOG"
      break
      ;;
    [Nn]) 
      echo "${NOTE} you chose not to set Thunar as the default file manager." | tee -a "$LOG"
      break
      ;;
    *)
      echo "Invalid input. Please enter 'y' or 'n'."
      ;;
  esac
done

printf "\n%.0s" {1..1}

 # Check for existing configs and copy if does not exist
for DIR1 in gtk-3.0 Thunar xfce4; do
  DIRPATH=~/.config/$DIR1
  if [ -d "$DIRPATH" ]; then
    echo -e "${NOTE} Config for $DIR1 found, no need to copy." 2>&1 | tee -a "$LOG"
  else
    echo -e "${NOTE} Config for $DIR1 not found, copying from assets." 2>&1 | tee -a "$LOG"
    cp -r assets/$DIR1 ~/.config/ && echo "${OK} Copy $DIR1 completed!" || echo "${ERROR} Failed to copy $DIR1 config files." 2>&1 | tee -a "$LOG"
  fi
done

printf "\n%.0s" {1..2}