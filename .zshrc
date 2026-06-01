# ~/.zshrc
# Config unica do zsh, sem frameworks.

# Historico.
mkdir -p "$HOME/.config/zsh"
HISTFILE="$HOME/.config/zsh/history"
HISTSIZE=5000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Comportamento geral.
setopt autocd
setopt interactive_comments
setopt no_beep
setopt prompt_subst
bindkey -e

# PATH.
typeset -U path PATH
path=(
	"$HOME/bin"
	"$HOME/.local/bin"
	"$HOME/.local/share/gem/ruby/3.3.0/bin"
	$path
)

# Ambiente.
export GPG_TTY="$(tty)"
export LESSHISTFILE=-
export TASKRC="$HOME/.config/.task/.taskrc"
export VISUAL=/usr/local/bin/nvim
export EDITOR=/usr/local/bin/nvim
export BLOCK_SIZE=1M
export OLLAMA_MODELS="$HOME/.config/.ollama/models"

# Cores basicas de terminal.
if command -v dircolors >/dev/null 2>&1; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi
fi

# Zoxide
eval "$(zoxide init zsh)"

# Completion nativa do zsh.
autoload -Uz compinit
mkdir -p "$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# Aliases migrados do bash.
alias ls='ls --color=auto'
alias s='sudo'
alias taskl='task list'
alias tt='task status:pending or end.after:today-1wk -DELETED all'
alias main='cd ~ && clear && tt && tmux rename-window main'
alias ia='cd ~/Documentos/python/llm && source bin/activate && tmux rename-window llm && llm chat -c -f concise'
alias cymatrix='cmatrix -C cyan'
alias apt='sudo apt update && apt list --upgradable'
alias nethack='tmux new-window -n nethack "/home/soth/Downloads/NetHack/Nethack-5.0.0/games/ttyhack.sh"'
alias vps='ssh -i /home/soth/.config/.ssh/id_ed root@216.238.99.112'
alias vpnon='sudo wg-quick up wg0'
alias vpnoff='sudo wg-quick down wg0'
alias vpnstatus='sudo wg'
alias sena='/home/soth/Documentos/python/sena/sena.py && sleep 3 && cat /home/soth/Documentos/python/sena/sena'
alias chess='xboard -ics -icshost freechess.org -icsport 5000 -icslogon ~/.config/ics.config'
alias vim='nvim'
alias irssi='irssi --home=~/.config/irssi/'
alias playball='TERM=xterm-256color playball'
alias pathos='cd "$HOME/Documentos/gamedev/pathos" && /usr/local/bin/nvim .'
alias lf='$HOME/.config/lf/lfub'

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

ok() {
	main &&
	tmux new-window -n nmutt 'neomutt' &&
	tmux new-window -n irssi 'irssi --home="$HOME/.config/irssi/"' &&
	tmux new-window -n newsboat 'newsboat' &&
	tmux new-window -n jopy 'joplin' &&
	tmux new-window -n codex 'codex' &&
	tmux new-window -n nethack 'ssh nethack@us.hardfought.org' &&
	tmux new-window -n pathos "zsh -lc 'cd \"$HOME/Documentos/gamedev/pathos\" && nvim .'" &&
	tmux next-window
}

# Prompt gruvbox com estado de git.
_prompt_git() {
	command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

	local branch state ahead behind upstream counts
	branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
	state="clean"

	if ! git diff --quiet --ignore-submodules -- 2>/dev/null; then
		state="dirty"
	fi
	if ! git diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
		state="${state}+staged"
	fi
	if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
		state="${state}+new"
	fi

	upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
	if [ -n "$upstream" ]; then
		counts=$(git rev-list --left-right --count HEAD..."$upstream" 2>/dev/null)
		ahead=${counts%%	*}
		behind=${counts##*	}
		[ "$ahead" != 0 ] && state="${state}+ahead:$ahead"
		[ "$behind" != 0 ] && state="${state}+behind:$behind"
	fi

	if [ "$state" = clean ]; then
		printf ' %%F{214}%%B[%%bgit:%s %s%%B]%%b%%f' "$branch" "$state"
	else
		printf ' %%F{214}%%B[%%bgit:%s %s%%B]%%b%%f' "$branch" "$state"
	fi
}

_set_prompt() {
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		PROMPT='%F{142}%n%B@%b%m%f %F{223}%~%f$(_prompt_git)
%F{214}%(#.#.$)%f '
	else
		PROMPT='%F{142}%n%B@%b%m%f %F{223}%~%f %F{214}%(#.#.$)%f '
	fi
}

precmd_functions+=(_set_prompt)
