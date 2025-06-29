HISTFILE=~/.zsh_hist
HISTSIZE=10000
SAVEHIST=1000
unsetopt autocd
bindkey -v

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto' alias egrep='egrep --color=auto'
fi

alias ls='xplr'

# The port number, 46368, is "godot" written on a T9 keyboard.
alias nvim-godot='nvim --listen 127.0.0.1:46368'
alias i3lock='i3lock -c 000000'

if test "$(ps aux | grep bash | wc -l)" -le 3; then
	cat /home/colin/goals.txt
fi

export PATH=\
"$PATH:/home/colin/.local/bin:\
/home/colin/.local/bin/scripts"

export VIMINIT="so ~/.vimrc"
export TERMINAL="wezterm"

export FZF_DEFAULT_OPTS="--tmux 80% --style full \
	--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

. "$HOME/.cargo/env"

bg_0="%K{236}"
fg_0="%F{202}"
fg_1="%F{214}"
s_0="%F{236}%f"
e_0="%F{236}%f"
sep_0="%F{214}%f"

function set-prompt()
{
	branch="[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)]"

	PROMPT="$sep_0"
	PROMPT+="$s_0%B$bg_0 $fg_0%n@%m %f%k%b$e_0$sep_0"
	PROMPT+="$s_0%B$bg_0 in $fg_1%~ %f%k$e_0$sep_0"
	PROMPT+="$s_0%B$bg_0 on $branch %k%b$e_0"
	PROMPT+=$'\n'
	PROMPT+="$sep_0  "

	RPROMPT="%?"
}

function newline()
{
	echo
}

source <(fzf --zsh)

zstyle :compinstall filename '/home/colin/.zshrc'

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit
autoload -Uz add-zsh-hook
autoload -U colors && colors
compinit
add-zsh-hook precmd set-prompt
add-zsh-hook precmd newline
