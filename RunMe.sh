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
  echo "Yes"
else
  echo "No"
fi

