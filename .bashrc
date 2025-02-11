# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# [alias]
#    pr = "!f() { git fetch -fu ${1:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$2/from:pr/$2 && git checkout pr/$2; }; f"



# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
# alias wget="curl -O $1"
alias cdlaunch="cd $HOME/git_repos/launch-ci"
alias jenkins="ssh 1010-R"
alias brew="ALL_PROXY=proxy.jpmchase.net:8443 brew"
alias projects="cd $HOME/git_repos/projects"
alias ios="cd $HOME/git_repos/projects/DIGITALMOBILE/ios"
alias android="cd $HOME/git_repos/projects/DIGITALMOBILE/android"
export PROJECTS="$HOME/git_repos/projects"

alias purge="rm -rfv \
~/derived_data/ \
~/Library/Developer/Xcode/DerivedData/ \
~/.gradle/ \
~/.m2/ \
~/swift_package_cache*/ \
~/Library/Caches/org.swift.swiftpm/ \
~/Library/org.swift.swiftpm/"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

awake(){

    HELP="syntax: awake [on|off]"
    ERR="INVALID ARG: Must pass exactly 1 arg [on|off]"

    if [ ${#} -ne 1 ] || ([ "${1}" != "on" ] && [ "${1}" != "off" ]);then
        printf "%s\n\t%s\n" "${HELP}" "${ERR}"
        return 1
    fi

    if [ "${1}" = "on" ] && [ -z "$(pgrep caffeinate)" ];then
        printf "(-‿-)\r"
        sleep .5
        printf "(ಠ_ಠ)\r"
        sleep .3
        nohup -- /usr/bin/caffeinate -disu &>/dev/null &
        return 0
    fi

    if [ "${1}" = "off" ] && [ -n "$(pgrep caffeinate)" ];then
        printf "(ಠ_ಠ)\r"
        sleep .5
        printf "(-‿-)\r"
        sleep .3
        kill $(pgrep caffeinate)
        return 0
    fi
}

who_dis(){
  if [ -z ${1} ];then
    echo "SID required"
    exit 1
  fi
  curl --silent --url "https://giamid-app.jpmchase.net/idowner/status/sidSearch/?sid=${1}&format=json" | jq
}


proxy_on(){
    PROXY='http://proxy.jpmchase.net:8443';
    export http_proxy="${PROXY}";
    export https_proxy="${PROXY}";
    export HTTP_PROXY="${PROXY}";
    export HTTPS_PROXY="${PROXY}";
    export ALL_PROXY="${PROXY}";
    export all_proxy="${PROXY}";
    unset -v PROXY
    git config --global http.proxy http://proxy.jpmchase.net:10443
}

proxy_off(){
    unset -v http_proxy;
    unset -v https_proxy;
    unset -v all_proxy;
    unset -v HTTP_PROXY;
    unset -v HTTPS_PROXY;
    unset -v ALL_PROXY
    git config --global --unset http.proxy
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Prompt Color Variables
BRAKCOLOR="\[\033[38;5;247m\]"
SECCOLOR="\[\033[38;5;59m\]"
PRICOLOR="\[\033[38;5;196m\]"
RESETCOLOR="\[\033[0m\]"

#Setting Custom 256-Color Prompt
export PS1="${BRAKCOLOR}[${SECCOLOR}\t${BRAKCOLOR}]-${BRAKCOLOR}[${PRICOLOR}\u${BRAKCOLOR}@${PRICOLOR}\h ${SECCOLOR}\W${BRAKCOLOR}]\$ ${RESETCOLOR}"

alias ssh='export TERM=xterm && ssh'

# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
# GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files
GIT_PROMPT_THEME=Solarized
# GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

GIT_PROMPT_START="${BRAKCOLOR}[${SECCOLOR}\t${BRAKCOLOR}]-${BRAKCOLOR}[${PRICOLOR}\u${BRAKCOLOR}@${PRICOLOR}\h ${SECCOLOR}\W${BRAKCOLOR}]${RESETCOLOR}"    # uncomment for custom prompt start sequence
GIT_PROMPT_END="$ "      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
# GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
source ~/.bash-git-prompt/gitprompt.sh

if [ -f ~/.git-completion.bash ]; then
    . "$HOME/.git-completion.bash"
fi

if [ -f ~/.tfl-completion.bash ]; then
    . "$HOME/.tfl-completion.bash"
fi

if [ -f ~/.atlas-completion.bash ]; then
    . "$HOME/.atlas-completion.bash"
fi



# source '~/JPMCenv'

# [[ $TERM != "screen" ]] && exec tmux -2
export PATH="$HOME/bin:$PATH"
export NUTMEG_PROJECT_PATH="/Users/O778195/git_repos/projects/nutmegdevelopment/nm-ios-app"
