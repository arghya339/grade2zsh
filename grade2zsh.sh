#!/usr/bin/env bash

# Copyright (C) 2025, Arghyadeep Mondal <github.com/arghya339>

Reset='\033[0m'
Red='\033[31m'
NeonRed='\033[38;2;255;0;0m'
Orange='\033[38;5;202m'
TrueOrange='\033[38;2;255;165;0m'
Yellow='\033[33m'
Green='\033[32m'
Blue='\033[34m'
TrueBlue='\033[38;5;021m'
Indigo='\033[38;5;54m'
TrueIndigo='\033[38;2;75;0;130m'
Violet='\033[38;5;93m'
TrueViolet='\033[38;2;138;43;226m'
Magenta='\033[35m'
NeonMagenta='\033[38;2;255;0;255m'
Cyan='\033[36m'
NeonCyan='\033[38;2;0;255;255m'
White='\033[37m'
whiteBG='\e[47m\e[30m'

good="\033[92;1m[✔]\033[0m"
bad="\033[91;1m[✘]\033[0m"
info="\033[94;1m[i]\033[0m"
running="\033[37;1m[~]\033[0m"
notice="\033[93;1m[!]\033[0m"
question="\033[93;1m[?]\033[0m"

if ! ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
  echo -e "$bad Oops! No Internet Connection available.\nConnect to the Internet and try again later."
  exit 1
fi

curl -sL -o "$HOME/.grade2zsh.sh" "https://raw.githubusercontent.com/arghya339/grade2zsh/refs/heads/main/grade2zsh.sh"
isMacOS=false; isAndroid=false; isFedora=false
if [[ "$(uname)" == "Darwin" ]]; then
  isMacOS=true
  [ ! -f "/usr/local/bin/grade2zsh" ] && ln -s $HOME/.grade2zsh.sh /usr/local/bin/grade2zsh
elif [[ -d "/sdcard" ]] && [[ -d "/system" ]]; then
  isAndroid=true
  [ ! -f "$PREFIX/bin/grade2zsh" ] && ln -s $HOME/.grade2zsh.sh $PREFIX/bin/grade2zsh
elif [[ -f "/etc/os-release" ]]; then
  if grep -qi "fedora" /etc/os-release 2>/dev/null; then
    isFedora=true
  fi
  [ ! -f "/usr/local/bin/grade2zsh" ] && sudo ln -s $HOME/.grade2zsh.sh /usr/local/bin/grade2zsh
fi
chmod +x $HOME/.grade2zsh.sh

# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh
print_grade2zsh () {
  FMT_RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[36m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;54m')
      $(printf '\033[35m')
    "
  FMT_BOLD=$(printf '\033[1m')
  FMT_RESET=$(printf '\033[0m')
  
  echo -e "       ${TrueBlue}https://github.com/arghya339/grade2zsh${Reset}"
  printf '%s          %s      %s      %s   __%s  %s  ___  %s    %s       %s__  %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s   ____ _%s_____%s____ _%s____/ /%s__ %s|__ \%s____%s  _____%s/ /_ %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s  / __ `/%s ___/%s __ `/%s __  /%s _ \%s__/ /%s_  /%s / ___/%s __ \%s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s / /_/ /%s /  %s/ /_/ /%s /_/ /%s  __/%s __/%s / /_%s(__  )%s / / /%s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s \__, /%s_/   %s\__,_/%s\__,_/%s\___/%s____/%s/___/%s____/%s_/ /_/ %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s/____/ %s      %s     %s        >_𝒟𝑒𝓋𝑒𝓁𝑜𝓅𝑒𝓇: @𝒶𝓇𝑔𝒽𝓎𝒶𝟥𝟥𝟫%s%s%s%s%s   %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '\n'
  printf '\n'
}

confirmPrompt() {
  Prompt=${1}
  Selected=${2:-0}  # :- set value as 0 if unset
  cols=$(stty size | awk '{print $2}')
  
  # breaks long prompts into multiple lines
  mapfile -t lines < <(fmt -w "$cols" <<< "$Prompt")
  
  # print all-lines except last-line
  last_line_index=$(( ${#lines[@]} - 1 ))  # ${#lines[@]} = number of elements in lines array
  for (( i=0; i<last_line_index; i++ )); do
    echo "${lines[i]}"
  done
  
  last_line="${lines[$last_line_index]}"
  llcc=${#last_line}
  
  [ $((cols - llcc)) -ge 17 ] && fits_on_last=true || { fits_on_last=false; echo -e "$last_line"; }
  
  echo -ne '\033[?25l'  # Hide cursor
  while true; do
    show_prompt() {
      echo -ne "\r\033[K"  # n=noNewLine r=returnCursorToStartOfLine \033[K=clearLine
      [ $fits_on_last == true ] && echo -ne "$last_line "
      [ $Selected -eq 0 ] && echo -ne "${whiteBG}➤ <Yes> $Reset   <No>" || echo -ne "  <Yes>  ${whiteBG}➤ <No> $Reset"  # highlight selected bt with white bg
    }; show_prompt

    read -rsn1 key
    case $key in
      $'\E')
      # /bin/bash -c 'read -r -p "Type any ESC key: " input && printf "You Entered: %q\n" "$input"'  # q=safelyQuoted
        read -rsn2 -t 0.1 key2  # -r=readRawInput -s=silent(noOutput) -t=timeout -n2=readTwoChar | waits upto 0.1s=100ms to read key 
        case $key2 in 
          '[C') Selected=1 ;;  # right arrow key
          '[D') Selected=0 ;;  # left arrow key
        esac
        ;;
      [Yy]*) Selected=0; show_prompt; break ;;
      [Nn]*) Selected=1; show_prompt; break ;;
      "") break ;;  # Enter key
    esac
  done
  echo -e '\033[?25h' # Show cursor
  return $Selected  # return Selected int index from this fun
}

menu() {
  local -n menu_options=$1
  local -n menu_buttons=$2
  
  selected_option=0
  selected_button=0
  
  show_menu() {
    printf '\033[2J\033[3J\033[H'
    print_grade2zsh  # call print_grade2zsh function
    echo "Navigate with [↑] [↓] [←] [→]"
    echo -e "Select with [↵]\n"
    for ((i=0; i<=$((${#menu_options[@]} - 1)); i++)); do
      if [ $i -eq $selected_option ]; then
        echo -e "${whiteBG}➤ ${menu_options[$i]} $Reset"
      else
        echo "${menu_options[$i]}"
      fi
    done
    echo
    for ((i=0; i<=$((${#menu_buttons[@]} - 1)); i++)); do
      if [ $i -eq $selected_button ]; then
        [ $i -eq 0 ] && echo -ne "${whiteBG}➤ ${menu_buttons[$i]} $Reset" || echo -ne "  ${whiteBG}➤ ${menu_buttons[$i]} $Reset"
      else
        [ $i -eq 0 ] && echo -n "  ${menu_buttons[$i]}" || echo -n "   ${menu_buttons[$i]}"
      fi
    done
    echo
  }

  printf '\033[?25l'
  while true; do
    show_menu
    read -rsn1 key
    case $key in
      $'\E')  # ESC
        # /bin/bash -c 'read -r -p "Type any ESC key: " input && printf "You Entered: %q\n" "$input"'  # q=safelyQuoted
        read -rsn2 -t 0.1 key2
        case "$key2" in
          '[A')  # Up arrow
            selected_option=$((selected_option - 1))
            [ $selected_option -lt 0 ] && selected_option=$((${#menu_options[@]} - 1))
            ;;
          '[B')  # Down arrow
            selected_option=$((selected_option + 1))
            [ $selected_option -ge ${#menu_options[@]} ] && selected_option=0
            ;;
          '[C')  # Right arrow
            [ $selected_button -lt $((${#menu_buttons[@]} - 1)) ] && selected_button=$((selected_button + 1))
            ;;
          '[D')  # Left arrow
            [ $selected_button -gt 0 ] && selected_button=$((selected_button - 1))
            ;;
        esac
        ;;
      '')  # Enter key
        break
        ;;
    esac
  done
  printf '\033[?25h'

  [ $selected_button -eq 0 ] && { printf '\033[2J\033[3J\033[H'; selected=$selected_option; }
  [ $selected_button -eq $((${#menu_buttons[@]} - 1)) ] && { printf '\033[2J\033[3J\033[H'; echo "Script exited !!"; exit 0; }
}

printf '\033[2J\033[3J\033[H'  # clear
if [ -f "$PREFIX/bin/zsh" ] && [ -d "$HOME/.oh-my-zsh" ]; then
  eButtons=("<Select>" "<Exit>")
  [ "$(basename $SHELL)" == "zsh" ] && options=("zsh→bash") || options=("$(basename $SHELL)→zsh")
  options+=("Update" "Reinstall" "Uninstall")
  while true; do
    menu "options" eButtons
    case "${options[$selected]}" in
      Update)
        if [ $isAndroid == true ]; then
          pkg update &>/dev/null  # It downloads latest package list with versions from Termux remote repository, then compares them to local (installed) pkg versions, and shows a list of what can be upgraded if they are different.
          # echo "$running Updating Termux pkg.."; pkg upgrade -y &>/dev/null
          apt list --upgradeable 2>/dev/null | grep -q "^git/" && { echo -e "$running Updating git.."; pkg install --only-upgrade git -y &>/dev/null; }
          apt list --upgradeable 2>/dev/null | grep -q "^zsh/" && { echo -e "$running Updating zsh.."; pkg install --only-upgrade zsh -y &>/dev/null; }
        elif [ $isMacOS == true ]; then
          brew outdated 2>/dev/null | grep -q "^git" && { echo -e "$running Updating git.."; brew upgrade git &>/dev/null; }
          brew outdated 2>/dev/null | grep -q "^zsh" && { echo -e "$running Updating zsh.."; brew upgrade zsh &>/dev/null; }
        elif [ $isFedora == true ]; then
          dnf --refresh list --upgrades 2>/dev/null | grep -q "^git" && { echo -e "$running Updating git.."; sudo dnf update git -y &>/dev/null; }
          dnf --refresh list --upgrades 2>/dev/null | grep -q "^zsh" && { echo -e "$running Updating zsh.."; sudo dnf update zsh -y &>/dev/null; }
        fi
        git -C "$ZSH" fetch origin &>/dev/null  # Fetch updates from the remote repository
        # Check if there are any changes (compare local and remote branches)
        omzLocal=$(git -C "$ZSH" rev-parse master 2>/dev/null)
        omzRemote=$(git -C "$ZSH" rev-parse origin/master 2>/dev/null)
        # If there is a difference, then update omz
        if [ "$omzLocal" != "$omzRemote" ]; then
          echo -e "$running Updating oh-my-zsh.."
          omz update &>/dev/null || sh ~/.oh-my-zsh/tools/upgrade.sh &>/dev/null
          # omz changelog; read -p "Press Enter to continue..."  # Show changelog
        fi
        echo -e "$running Pulling oh-my-zsh plugins.."
        git pull https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
        git pull https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null
        sleep 1  # wait 1 second
        ;;
      Reinstall)
        if [ $isAndroid == true ]; then
          echo -e "$running Reinstalling zsh.."; pkg reinstall zsh -y &>/dev/null
          echo -e "$running Reinstalling Git.."; pkg reinstall git -y &>/dev/null
        elif [ $isMacOS == true ]; then
          echo -e "$running Reinstalling Git.."; brew reinstall git &>/dev/null
        elif [ $isFedora == true ]; then
          echo -e "$running Reinstalling zsh.."; sudo dnf reinstall zsh -y &>/dev/null
          echo -e "$running Reinstalling Git.."; sudo dnf reinstall git -y &>/dev/null
        fi
        echo -e "$running Reinstalling oh-my-zsh.."
        # yes | uninstall_oh_my_zsh  # uninstall_oh_my_zsh
        [ $isMacOS == true ] && sed -i '' '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh || sed -i '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh
        sh $HOME/.oh-my-zsh/tools/uninstall.sh &>/dev/null
        # rm -rf ~/.oh-my-zsh
        rm ~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H)*
        # rm -f ~/.zsh_history
        yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
        grep -q "^# zstyle ':omz:update' verbose silent" "$HOME/.zshrc" && sed -i 'zstyle ':omz:update' verbose silent/s/# //' "$HOME/.zshrc"  # uncomment (enabled) zsh auto update
        grep -q "^# zstyle ':omz:update' verbose silent" "$HOME/.zshrc" && sed -i 'zstyle ':omz:update' verbose silent/s/# //' "$HOME/.zshrc"  # limit update verbosity
        export SHELL="$HOME/.oh-my-zsh"
        chsh -s $PREFIX/bin/zsh  # Set zsh as default interpreter
        echo -e "$running Cloning zsh-autosuggestions plugins.."; git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
        grep -q '^source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> ~/.zshrc  # Add zsh-autosuggestions source to oh-my-zsh .zshrc file
        # cat ~/.zshrc | grep ^"source $ZSH/custom/plugins/zsh-autosuggestions"  # print added line
        echo -e "$running Cloning zsh-syntax-highlighting plugins.."; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null
        grep -q '^source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> ~/.zshrc  # Add zsh-syntax-highlighting source to oh-my-zsh .zshrc
        # cat ~/.zshrc | grep ^"source $ZSH/custom/plugins/zsh-syntax-highlighting"  # print added line in .zshrc
        sleep 1  # wait 1 second
        ;;
      Uninstall)
        confirmPrompt "Do you want to change your default shell to bash?" "1" && opt=Yes || opt=No  # Prompt for user choice on changing the default login shell
        case "$opt" in
          Yes)
            if [ $isAndroid == true ]; then
              echo -e "$running Uninstalling Git.."; pkg uninstall git -y &>/dev/null
              echo -e "$running Uninstalling zsh.."; pkg uninstall zsh -y &>/dev/null
              grep -q "^terminal-cursor-blink-rate = 500" "$HOME/.termux/termux.properties" && sed -i 's/^terminal-cursor-blink-rate = 500/# terminal-cursor-blink-rate = 0/' "$HOME/.termux/termux.properties"
              grep -q "^terminal-cursor-style = bar" "$HOME/.termux/termux.properties" && sed -i 's/^terminal-cursor-style = bar/# terminal-cursor-style = block/' "$HOME/.termux/termux.properties"
              [ -f $PREFIX/etc/motd.backup ] && mv $PREFIX/etc/motd.backup $PREFIX/etc/motd
              $PREFIX/bin/grade2zsh
            elif [ $isMacOS == true ]; then
              echo -e "$running Uninstalling Git.."; brew uninstall git &>/dev/null
              rm -f /usr/local/bin/grade2zsh
            elif [ $isFedora == true ]; then
              echo -e "$running Uninstalling Git.."; sudo dnf remove git -y &>/dev/null
              echo -e "$running Uninstalling zsh.."; sudo dnf remove zsh -y &>/dev/null
              sudo rm -f /usr/local/bin/grade2zsh
            fi
            echo -e "$running Uninstalling oh-my-zsh.."
            # yes | uninstall_oh_my_zsh  # uninstall_oh_my_zsh
            [ $isMacOS == true ] && sed -i '' '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh || sed -i '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh
            sh $HOME/.oh-my-zsh/tools/uninstall.sh &>/dev/null
            # rm -rf ~/.oh-my-zsh
            rm -f ~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H)* ~/.zsh_history ~/.zcompdump* $HOME/.grade2zsh.sh
            sleep 1  # wait 1 second
            printf '\033[2J\033[3J\033[H'  # clear Terminal
            echo -e "Thanks for trying out Zsh. It's been uninstalled.\nDon't forget to restart your terminal!"
            if [ $isAndroid == true ]; then termux-open-url "https://github.com/arghya339/grade2zsh"; elif [ $isMacOS == true ]; then open "https://github.com/arghya339/grade2zsh"; else xdg-open "https://github.com/arghya339/grade2zsh" &>/dev/null; fi
            [ $isMacOS == false ] && { chsh -s $PREFIX/bin/bash && exec $PREFIX/bin/bash; }  # Restore Default Shell and Restart bash Interpreter
            break
            ;;
          No) echo -e "$notice Shell change skipped !!"; sleep 1 ;;
        esac
        ;;
      *) [ "${options[selected]}" == "zsh→bash" ] && { chsh -s $PREFIX/bin/bash; echo -e "$good default login shell changed to bash successfully! please restart Termux session to take effect."; exit 0; } || { chsh -s $PREFIX/bin/zsh; echo -e "$good default login shell changed to zsh successfully! please restart Termux session to take effect."; exit 0; } ;;
    esac
  done
else
  print_grade2zsh  # Call print_grade2zsh function
  if [ $isAndroid == true ]; then
    echo -e "$running Updating Termux pkg.."
    pkill pkg && { pkg update && pkg upgrade -y; } &>/dev/null  # discarding output
    pkill apt  # Forcefully kill apt process
    pkill dpkg && yes | dpkg --configure -a  # Forcefully kill dpkg process and configure dpkg
    echo "deb https://mirrors.ustc.edu.cn/termux/termux-main stable main" > $PREFIX/etc/apt/sources.list && pkg update &>/dev/null && pkg --check-mirror update &>/dev/null  # termux-change-repo && pkg --check-mirror update
    [ ! -f "$PREFIX/bin/zsh" ] && { echo -e "$running Installing zsh Interpreter.."; pkg install --upgrade zsh -y &>/dev/null; }  # install zsh pkg
    [ ! -f "$PREFIX/bin/git" ] && { echo -e "$running Installing Git.."; pkg install --upgrade git -y &>/dev/null; }  # install git pkg
    Android=$(getprop ro.build.version.release | cut -d. -f1)
    ([ $Android -eq 6 ] && [ ! -f "$HOME/.termux/termux.properties" ]) && { mkdir -p "$HOME/.termux"; echo "terminal-cursor-blink-rate = 500" > "$HOME/.termux/termux.properties"; echo "terminal-cursor-style = bar" >> "$HOME/.termux/termux.properties"; }  # make .termux dir & create termux.properties file & change cursor blink rate to 500 & cursor style to bar
    if [ $Android -ge 6 ]; then
      grep -q "^# terminal-cursor-blink-rate" "$HOME/.termux/termux.properties" && sed -i 's/^# terminal-cursor-blink-rate = .*/terminal-cursor-blink-rate = 500/' "$HOME/.termux/termux.properties"  # uncomment & change cursor blink rate to 500
      grep -q "^# terminal-cursor-style" "$HOME/.termux/termux.properties" && sed -i 's/^# terminal-cursor-style = .*/terminal-cursor-style = bar/' "$HOME/.termux/termux.properties"  # uncomment & change cursor style to bar
    fi
    mv $PREFIX/etc/motd $PREFIX/etc/motd.backup
  elif [ $isMacOS == true ]; then
    [ ! -f "/usr/local/bin/git" ] && { echo -e "$running Installing Git.."; brew install git &>/dev/null; }
  elif [ $isFedora == true ]; then
    [ ! -f "$PREFIX/bin/zsh" ] && { echo -e "$running Installing zsh.."; sudo dnf install zsh -y &>/dev/null; }
    [ ! -f "$PREFIX/bin/git" ] && { echo -e "$running Installing Git.."; sudo dnf install git -y &>/dev/null; }
  fi
  # Install oh-my-zsh (an zsh plugin)
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "$running Installing oh-my-zsh.."; yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
    if [ $isMacOS == true ]; then
      grep -q "^# zstyle ':omz:update' mode auto" "$HOME/.zshrc" && sed -i '' "s/^# \(zstyle ':omz:update' mode auto\)/\1/" "$HOME/.zshrc"  # uncomment (enabled) zsh auto update config in oh-my-zsh zshrc file
      grep -q "^# zstyle ':omz:update' verbose silent" "$HOME/.zshrc" && sed -i '' "s/^# \(zstyle ':omz:update' verbose silent\)/\1/" "$HOME/.zshrc" || echo "zstyle ':omz:update' verbose silent  # only errors"  >> ~/.zshrc  # limit update verbosity
    else
      grep -q "^# zstyle ':omz:update' mode auto" "$HOME/.zshrc" && sed -i "s/^# \(zstyle ':omz:update' mode auto\)/\1/" "$HOME/.zshrc"  # uncomment (enabled) zsh auto update config in oh-my-zsh zshrc file
      grep -q "^# zstyle ':omz:update' verbose silent" "$HOME/.zshrc" && sed -i 'zstyle ':omz:update' verbose silent/s/# //' "$HOME/.zshrc" || echo "zstyle ':omz:update' verbose silent  # only errors"  >> ~/.zshrc  # limit update verbosity
      export SHELL="$HOME/.oh-my-zsh"
      echo -e "$running Changing your shell to zsh..."; chsh -s $PREFIX/bin/zsh  # Set zsh as default interpreter
    fi
  fi
  # Clone and add zsh-autosuggestions plugins to oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo -e "$running Cloning zsh-autosuggestions plugins.."; git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
    grep -q '^source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> ~/.zshrc  # Add zsh-autosuggestions source to oh-my-zsh .zshrc file
    #cat ~/.zshrc | grep ^'source "$ZSH/custom/plugins/zsh-autosuggestions"'  # print added line
    echo ": 1740403030:0;exit" >> ~/.zsh_history  # add exit command to .zsh_history file for auto suggestions
    echo ": 1740407010:0;grade2zsh" >> ~/.zsh_history  # add script command to .zsh_history file for auto suggestions
  fi
  # Clone and add zsh-syntax-highlighting plugins to oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo -e "$running Cloning zsh-syntax-highlighting plugins.."; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
    grep -q '^source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> ~/.zshrc  # Add zsh-syntax-highlighting source to oh-my-zsh .zshrc
    #cat ~/.zshrc | grep ^'source "$ZSH/custom/plugins/zsh-syntax-highlighting"'  # print added line
  fi
  # Add zsh-autosuggestions & zsh-syntax-highlighting if it's not already in the plugins list
  if [ $isMacOS == true ]; then
    sed -i '' '/^plugins=(/ { /zsh-autosuggestions/! s/)$/ zsh-autosuggestions)/; /zsh-syntax-highlighting/! s/)$/ zsh-syntax-highlighting)/; }' ~/.zshrc
  else
    sed -i '/^plugins=(/ { /zsh-autosuggestions/! s/)$/ zsh-autosuggestions)/; /zsh-syntax-highlighting/! s/)$/ zsh-syntax-highlighting)/; }' ~/.zshrc
  fi
  echo -e "${Green}Shell successfully changed to 'zsh'.${Reset}\nDon't forget to restart your terminal!"
  if [ $isAndroid == true ]; then
    termux-reload-settings  # Reload (restart) Termux settings
    exec $PREFIX/bin/dash  # Restart dash Interpreter
  elif [ $isMacOS == true ]; then
    exec $PREFIX/bin/zsh  # Restart zsh Interpreter
  elif [ $isFedora == true ]; then
    exec $PREFIX/bin/bash  # Restart bash Interpreter
  fi
  bash $(realpath "$0")  # run script again
  exit 0  # exit
fi
#############################################
