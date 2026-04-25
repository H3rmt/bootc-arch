HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=10000
setopt autocd nomatch notify incappendhistory
unsetopt beep
bindkey -e

zstyle ':compinstall filename ' ret '~/.zshrc'
autoload -Uz compinit && compinit

## custom
eval "$(zoxide init zsh)"

bindkey "^[[1;5C" forward-word;
bindkey "^[[1;5D" backward-word;
bindkey "^[[3~" delete-char;

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}