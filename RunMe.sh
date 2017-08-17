  #! /bin/bash

  # Init file to set up these config files.

  @confirm() {
    local message="$1"

    echo -n "> $message (y/n) "

    while true ; do
      read -s -n 1 choice
      case "$choice" in
        y|Y ) echo "Y" ; return 0 ;;
        n|N ) echo "N" ; return 1 ;;
      esac
    done
  }



  if @confirm 'This will overwrite your current config settings.  Are you sure you want to do this?' ; then
     if [[ $(git remote show origin -n | grep "Fetch URL:" | grep -o "ConfigFiles.git") == "ConfigFiles.git" ]]; then
         echo "Deleting .bash-git-prompt"
         rm -rf ~/.bash-git-prompt/
         echo "Deleting .vim/ folder"
         rm -rf ~/.vim/
         echo "Deleting .bashrc"
         rm ~/.bashrc
         echo "Deleting .vimrc"
         rm ~/.vimrc
         echo "Copying .vim/ folder"
         cp -r .vim/ ~/.vim/
         echo "Copying .bashrc"
         cp .bashrc ~/.bashrc
         echo "Copying .vimrc"
         cp .vimrc ~/.vimrc

         echo "Cloning the latest version of .bash-git-prompt using ssh.  If this fails please clone https://github.com/magicmonty/bash-git-prompt to your home directory and set it as a hidden folder (.bash-git-prompt)"
         cd ~
         git clone git@github.com:magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1

     else
         echo "This script does not appear to be in the proper directory.. PLease clone the repo and run it from the cloned directory."
     fi

  else
    echo "No"
  fi
