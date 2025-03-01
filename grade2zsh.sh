#!/usr/bin/dash

ln -s $HOME/grade2zsh.sh $PREFIX/bin/grade2zsh  # symlink (shortcut of grade2zsh.sh)
chmod +x $HOME/grade2zsh.sh  # give execute permission to grade2zsh

# Apply the grade2zsh color to the eye shape and print it
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

# Local Variable
fullScriptPath=$(realpath "$0")  # Get the full path of the currently running script

# Colored log indicators
good="\033[92;1m[✔]\033[0m"
bad="\033[91;1m[✘]\033[0m"
info="\033[94;1m[i]\033[0m"
running="\033[37;1m[~]\033[0m"
notice="\033[93;1m[!]\033[0m"
question="\033[93;1m[?]\033[0m"

# --- Checking Internet Connection ---
if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1 ; then
    echo "$bad Oops! No Internet Connection available.\nConnect to the Internet and try again later."
    return 1
fi

# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh
print_grade2zsh () {
  <<comment
  FMT_RAINBOW="
      $(printf '\033[38;2;255;0;0m')
      $(printf '\033[38;2;255;97;0m')
      $(printf '\033[38;2;247;255;0m')
      $(printf '\033[38;2;0;255;30m')
      $(printf '\033[36m')
      $(printf '\033[38;2;77;0;255m')
      $(printf '\033[38;2;168;0;255m')
      $(printf '\033[38;5;54m')
      $(printf '\033[35m')
    "
comment
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

  # Construct the grade2zsh shape using string concatenation (ANSI Slan Font)
  printf '%s          %s      %s      %s   __%s  %s  ___  %s    %s       %s__  %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s   ____ _%s_____%s____ _%s____/ /%s__ %s|__ \%s____%s  _____%s/ /_ %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s  / __ `/%s ___/%s __ `/%s __  /%s _ \%s__/ /%s_  /%s / ___/%s __ \%s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s / /_/ /%s /  %s/ /_/ /%s /_/ /%s  __/%s __/%s / /_%s(__  )%s / / /%s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s \__, /%s_/   %s\__,_/%s\__,_/%s\___/%s____/%s/___/%s____/%s_/ /_/ %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s/____/ %s      %s     %s        >_𝒟𝑒𝓋𝑒𝓁𝑜𝓅𝑒𝓇: @𝒶𝓇𝑔𝒽𝓎𝒶𝟥𝟥𝟫%s%s%s%s%s   %s\n'  $FMT_RAINBOW $FMT_RESET
  echo "${TrueBlue}https://github.com/arghya339/grade2zsh${Reset}\n"
  printf '\n'
  printf '\n'
}

clear  # clear Terminal

if [ -f "$PREFIX/bin/zsh" ] && [ -d "$HOME/.oh-my-zsh" ]; then
    while true; do
        print_grade2zsh  # call print_grade2zsh function here
        echo "Up. Update \nRe. Reinstall \nUn. Uninstall \nQu. Quit \n"
        read -r -p "Select: " input
        case "$input" in
          [Uu][pp]*)
            { rm $HOME/grade2zsh.sh && curl -o "$HOME/grade2zsh.sh" "https://raw.githubusercontent.com/arghya339/grade2zsh/refs/heads/main/grade2zsh.sh"; } > /dev/null 2>&1
            # echo "$running Updating Termux pkg.."
            # pkg upgrade -y > /dev/null 2>&1
            if apt list --upgradeable 2>/dev/null | grep -q "^git/"; then
              echo "$running Updating git.."
              pkg install git --upgrade
            fi
            if apt list --upgradeable 2>/dev/null | grep -q "^zsh/"; then
              echo "$running Updating zsh.."
              pkg install zsh --upgrade
            fi
            echo "$running Updating oh-my-zsh.."
            omz update > /dev/null 2>&1
            echo "$running Pulling oh-my-zsh plugins.."
            git pull https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
            git pull https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
            sleep 1  # wait 1 second
            ;;
          [Rr][Ee]*)
            echo "$running Reinstalling zsh.."
            pkg reinstall zsh -y > /dev/null 2>&1
            echo "$running Reinstalling Git.."
            pkg reinstall git -y > /dev/null 2>&1
            echo "$running Reinstalling oh-my-zsh.."
            sed -i '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh
            # uninstall_oh_my_zsh
            # yes | uninstall_oh_my_zsh
            sh $HOME/.oh-my-zsh/tools/uninstall.sh
            # rm -rf ~/.oh-my-zsh
            rm ~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H)*
            rm ~/.zsh_history
            yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
            # echo "zstyle ':omz:update' mode auto  # update automatically without asking" >> ~/.zshrc  # Add zsh Auto update config in oh-my-zsh zshrc file
            echo "zstyle ':omz:update' verbose silent # only errors"  >> ~/.zshrc  # omz setting for silent update
            # -- set zsh as Termux default interpreter --
            export SHELL="$HOME/.oh-my-zsh"
            chsh -s zsh  # set zsh as default
            echo "$running Cloning zsh-autosuggestions plugins.."
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
            # Add zsh-autosuggestions source to oh-my-zsh .zshrc file
            grep -q '^source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> ~/.zshrc
            # cat ~/.zshrc | grep ^"source $ZSH/custom/plugins/zsh-autosuggestions"  # print added line
            echo "$running Cloning zsh-syntax-highlighting plugins.."
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
            # Add zsh-syntax-highlighting source to oh-my-zsh .zshrc
            grep -q '^source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> ~/.zshrc
            # cat ~/.zshrc | grep ^"source $ZSH/custom/plugins/zsh-syntax-highlighting"  # print added line in .zshrc
            sleep 1  # wait 1 second
            ;;
          [Uu][Nn]*)
            # Prompt for user choice on changing the default login shell
            echo "${Yellow}Do you want to uninstall zsh and change your default shell to bash/dash? [Y/n]${Reset}"
            read -r -p "Select: " opt
            case $opt in
              y*|Y*|"")
                echo "$running Uninstalling Git.."
                pkg uninstall git -y > /dev/null 2>&1
                echo "$running Uninstalling oh-my-zsh.."
                sed -i '/read -r -p "Are you sure you want to remove Oh My Zsh? \[y\/N\] " confirmation/,/^fi$/ s/^/# /' $HOME/.oh-my-zsh/tools/uninstall.sh
                # uninstall_oh_my_zsh
                # yes | uninstall_oh_my_zsh
                sh $HOME/.oh-my-zsh/tools/uninstall.sh
                # rm -rf ~/.oh-my-zsh
                rm ~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H)*
                rm ~/.zsh_history
                echo "$running Uninstalling zsh.."
                pkg uninstall zsh -y > /dev/null 2>&1
                #echo "$running Remove grade2zsh.sh file.."
                #rm $fullScriptPath
                # exec $PREFIX/bin/zsh  # Restart zsh Interpreter
                sleep 1  # wait 1 second
                clear  # clear Terminal
                echo "$info zsh uninstalled successfully, Please close then reopen Termux to take effect. \nTo close Termux type: exit"
                sleep 5  # wait 5 seconds
                break  # Break out of the loop
                ;;
              n*|N*) echo "$notice Shell change skipped.";sleep 1 ;;
              *) echo "$info Invalid choice. Shell change skipped."; sleep 2 ;;
            esac
            ;;
          [Qq]*)
            echo "$info Exiting.."
            sleep 0.5  # wait 500 milliseconds
            clear  # clear Terminal
            break  # Break out of the loop
            ;;
          *)
            echo "$info Invalid input! Please enter: Up / Re / Un / Qu"
            sleep 3  # wait 3 seconds (1 seconds = 1000 milliseconds)
            ;;
        esac
        clear
        echo  # Add empty line for spacing before next prompt
    done
else
  print_grade2zsh  # call print_grade2zsh function
  # --- Update Termux pkg ---
  echo "$running Updating Termux pkg.."
  pkill pkg && { pkg update && pkg upgrade -y; } > /dev/null 2>&1  # discarding output
 
  pkill apt  # Forcefully kill apt process
  pkill dpkg && yes | dpkg --configure -a  # Forcefully kill dpkg process and configure dpkg

  # --- install zsh pkg ---
  if [ ! -f "$PREFIX/bin/zsh" ]; then
    echo "$running Installing zsh Interpreter.."
    pkg install zsh -y > /dev/null 2>&1
  fi

  # --- install git pkg ---
  if [ ! -f "$PREFIX/bin/git" ]; then
    echo "$running Installing Git.."
    pkg install git -y > /dev/null 2>&1
  fi

  # --- install oh-my-zsh is an zsh plugin ---
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "$running Installing oh-my-zsh.."
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
    echo "zstyle ':omz:update' mode auto  # update automatically without asking" >> ~/.zshrc  # Add zsh Auto update config in oh-my-zsh zshrc file
    echo "zstyle ':omz:update' verbose silent # only errors"  >> ~/.zshrc
    # -- set zsh as Termux default interpreter --
    export SHELL="$HOME/.oh-my-zsh"
    chsh -s zsh  # Change Your Default Shell
    # echo $0  # echo $SHELL
  fi

  # clone and add zsh-autosuggestions plugins to oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "$running Cloning zsh-autosuggestions plugins.."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
    # Add zsh-autosuggestions source to oh-my-zsh .zshrc file
    grep -q '^source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> ~/.zshrc
    cat ~/.zshrc | grep ^'source "$ZSH/custom/plugins/zsh-autosuggestions"'  # print added line
    echo " 1740403030:0;exit" >> ~/.zsh_history  # add exit command to .zsh_history file for auto suggestions
    echo "
    : 1740407010:0;grade2zsh" >> ~/.zsh_history  # add script command to .zsh_history file for auto suggestions
  fi

  # clone and add zsh-syntax-highlighting plugins to oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "$running Cloning zsh-syntax-highlighting plugins.."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
    # Add zsh-syntax-highlighting source to oh-my-zsh .zshrc
    grep -q '^source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"$' ~/.zshrc || echo 'source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> ~/.zshrc
    cat ~/.zshrc | grep ^'source "$ZSH/custom/plugins/zsh-syntax-highlighting"'  # print added line
  fi

  # grep -vF 'plugins=(git)' ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc  # remove this line from .zshrc
  # echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> ~/.zshrc  # add this line into .zshrc
  sleep 1  # wait 1 second
  # exec $PREFIX/bin/zsh  # Restart zsh Interpreter
  echo "$info zsh installed successfully, please restart Termux to take effect."
  sleep 3  # wait 3 seconds
  clear  # clear previous session
  sh $fullScriptPath  # run script again
  exit 0  # exit from script loop
fi

#############################################
