#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$HOME/.local/bin:$PATH"
source /usr/share/nvm/init-nvm.sh

alias dotfiles='/usr/sbin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
