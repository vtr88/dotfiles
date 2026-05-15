# ~/.bashrc: executed by bash(1) for non-login shells.

case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

export GPG_TTY="$(tty)"
export LESSHISTFILE=-
export TASKRC="$HOME/.config/.task/.taskrc"
export VISUAL=vim
export EDITOR=vim
export BLOCK_SIZE=1M
export OLLAMA_MODELS="$HOME/.config/.ollama/models"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot="$(cat /etc/debian_chroot)"
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

case "$TERM" in
    xterm*|rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

alias s='sudo'
alias apt='sudo apt update && apt list --upgradable'
alias taskl='task list'
alias tt='task status:pending or end.after:today-1wk -DELETED all'
alias main='cd "$HOME" && clear && tt && tmux rename-window main'
alias ia='cd "$HOME/Documentos/python/llm" && source bin/activate && tmux rename-window llm && llm chat -c -f concise'
alias cymatrix='cmatrix -C cyan'
alias nethack='nethack'
alias vpnon='sudo wg-quick up wg0'
alias vpnoff='sudo wg-quick down wg0'
alias vpnstatus='sudo wg'
alias sena='$HOME/Documentos/python/sena/sena.py && sleep 3 && cat "$HOME/Documentos/python/sena/sena"'
alias chess='xboard -ics -icshost freechess.org -icsport 5000 -icslogon ~/.config/ics.config'
alias vim='nvim'
alias irssi='irssi --home="$HOME/.config/irssi/"'
alias playball='TERM=xterm-256color playball'

if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

ok() {
    main &&
    tmux new-window -n mutt 'neomutt' &&
    tmux new-window -n irssi 'irssi --home="$HOME/.config/irssi/"' &&
    tmux new-window -n newsboat 'newsboat' &&
    tmux new-window -n jopy 'joplin' &&
    tmux new-window -n llm "bash -lc 'cd \"$HOME/Documentos/python/llm\" && . bin/activate && llm chat -c -f concise; exec bash'" &&
    tmux next-window
}

[ -r /etc/motd ] && cat /etc/motd
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
