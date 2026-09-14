# ~/.bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export SYSTEMD_PAGER=""

export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias h='history'
alias j='jobs -l'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias wget='wget -c'
alias psu='ps aux --sort=-%cpu | head'
alias psm='ps aux --sort=-%mem | head'

shopt -s cdspell
shopt -s dirspell
shopt -s checkwinsize
shopt -s histappend

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="ls:cd:cd -:pwd:exit:history:* --help"
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
fi

if [[ $EUID -eq 0 ]]; then
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
export PS1

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi

if [ -f /usr/share/fzf/shell/completion.bash ]; then
  source /usr/share/fzf/shell/completion.bash
fi
