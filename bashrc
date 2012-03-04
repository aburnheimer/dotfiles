#.bashrc

# Source global definitions
if [ -f /etc/profile ]; then
	. /etc/profile
fi

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ -z "$PS1" ]] || [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi

# Shell is interactive.  It is okay to produce output at this point,
# though this example doesn't produce any.  Do setup for
# command-line interactivity.

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

TZ='America/New_York'; export TZ

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then

	# Smart colorized aliases - asb 01/03/04
	if [[ `uname -s` == "Linux" ]]; then
		# set variable identifying the chroot you work in (used in the prompt below)
		if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
			debian_chroot=$(cat /etc/debian_chroot)
		fi
		#PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
		#PS1='<\A> [\u@\h \W]\$ '
		# enable color support of ls and also add handy aliases
		if [ "$TERM" != "dumb" ]; then
			eval "`dircolors -b`"
		fi

		# make less more friendly for non-text input files, see lesspipe(1)
		[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

		alias ls="ls -F --color=auto"
		alias sl="ls"
		alias du="du -Shc"
		# alias rm="mv -f --target-directory=/home/burnheimera/.Trash" # for Nautilus < 2.22.2
		alias rm="mv -f --target-directory=/home/burnheimera/.local/share/Trash" # for Nautilus >= 2.22.2
		alias waste="/bin/rm -Rf"
		alias minicom="minicom -o"
		stty sane
	fi

	if [[ `uname -s` == "CYGWIN_NT-5.1" ]]; then
		PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
		#PS1='<\A> [\u@\h \W]\$ '
		# colors for ls, etc.  Prefer ~/.dir_colors #64489
		if [[ -f ~/.dir_colors ]]; then
			eval `dircolors -b ~/.dir_colors`
		else
			eval `dircolors -b /etc/DIR_COLORS`
		fi
		alias ls="ls -F --color=auto"
		alias sl="ls"
		alias cdd="cd ~/My\ Documents"
		alias du="du -Shc"
		alias rm="mv -f --target-directory=/cygdrive/c/RECYCLER/`ls /cygdrive/c/RECYCLER/`"
		alias waste="/bin/rm -Rf"
		#alias xterm='xterm -display :0.0 -sl 1000 -sb -rightbar -ms red -fg yellow -bg black -l -e /usr/bin/bash'
		alias xterm='xterm -display :0.0 -sl 1000 -sb -rightbar -ms red -fg yellow -bg black -e /usr/bin/bash'
	fi

	if [[ `uname -s` == "Darwin" ]]; then
		PS1='<\A> [\u@\h \W]\$ '
		alias ls="ls -GF "
		alias sl="ls"
		alias du="du -hc"
		#export MANPATH=/usr/share/man:/usr/local/share/man:/usr/local/man:/usr/X11R6/man
		# Inspired by MacPorts Installer addition on 2011-09-13_at_15:32:53: adding an appropriate PATH variable for use with MacPorts.
		PATH=/opt/local/bin:/opt/local/sbin:$PATH
		# Finished adapting your PATH environment variable for use with MacPorts.
		#export DISPLAY=:0.0
		#stty erase 
	fi

	if [[ `uname -s` == "SunOS" ]]; then
		PS1="[`echo $USER`@`echo $HOST`]$ "
		alias ls="ls -F "
		alias sl="ls"
		alias du="du -ho"
		alias rm="rm -i"
	fi

fi

# Change the window title of X terminals 
# set a fancy prompt (non-color, unless we know we "want" color)
if [[ $SHELL == "zsh" ]]; then
	case "$TERM" in
	xterm-color)
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		;;
	screen)
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		#PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
	*)
		PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
		;;
	esac
fi

case $TERM in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
esac

PATH=$HOME/.usr/local/bin:$PATH

# some more helpful ls aliases - asb
alias l.="ls -d .*"
alias ll='ls -l'
alias la='ls -A'
alias l='ls -C'
alias grep='grep --color'
alias grepnosvn='grep -r --exclude '\''*.svn*'\'''
alias personal_ssh_id='ssh-add ~/.ssh/id_rsa-user@email.domain.tld'

if [ `which colordiff` ]; then
	alias diff='colordiff'
fi

alias ssh='ssh -YA'

EDITOR=vim
SVN_EDITOR=vim
SVN_USER=username
HISTFILESIZE=4000
HISTSIZE=4000

export PATH PS1 SVN_EDITOR HISTFILESIZE HISTSIZE

# uncomment the following to activate bash-completion:
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

# vim:set nowrap:
