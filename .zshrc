HISTFILE=~/.zsh_hist
HISTSIZE=10000
SAVEHIST=1000
unsetopt autocd
bindkey -v

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto' alias egrep='egrep --color=auto'
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
# The port number, 46368, is "godot" written on a T9 keyboard.
alias nvim-godot='nvim --listen 127.0.0.1:46368'
alias i3lock='i3lock -c 000000'

if test "$(ps aux | grep bash | wc -l)" -le 3; then
	cat /home/colin/todo.todo
fi

export PATH=\
"$PATH:/home/colin/.local/bin:\
/home/colin/.local/bin/scripts"

export VIMINIT="source /home/colin/data/config-files/vimfiles/vimrc"
export TERMINAL="wezterm"

. "$HOME/.cargo/env"

bg_0="%K{236}"
fg_0="%F{202}"
fg_1="%F{214}"
end_0="%F{236}%f"

function set-prompt()
{
	branch="[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)]"

	PROMPT="%B$bg_0$fg_0%n@%m%f $fg_1%~%f $branch%k$end_0%b"$'\n'"> "
	RPROMPT="%?"
}

function newline()
{
	echo
}

zstyle :compinstall filename '/home/colin/.zshrc'

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit
autoload -Uz add-zsh-hook
autoload -U colors && colors
compinit
add-zsh-hook precmd set-prompt
add-zsh-hook precmd newline
