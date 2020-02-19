alias et='emacsclient -t'
alias emacskill='emacsclient -e "(kill-emacs)"'

function ec() {
    if [ -z $1 ]; then
        emacsclient -c &
    else
        emacsclient -c "$1" &
    fi
}

alias pg='ping -c 5 8.8.8.8'
alias restart="sudo netctl stop eduroam && sudo netctl start eduroam"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 100% --reverse --preview 'coderay {} || head -100 {}'"
export PATH=/Users/rickypinder/.local/bin:/usr/local/bin:$HOME/bin:$PATH
export SOBOLE_THEME_MODE=dark
export SOBOLE_DEFAILT_USER=ricky
export ALTERNATE_EDITOR=""

source ~/antigen.zsh
autoload -U colors && colors
setopt promptsubst

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen apply

