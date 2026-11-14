# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export FZF_DEFAULT_OPTS='
  --color=dark
  --color=fg:-1,bg:-1,hl:#586e75,fg+:#839496,bg+:#073642,hl+:#719e07
  --color=info:#b58900,prompt:#268bd2,pointer:#719e07,marker:#719e07,spinner:#b58900
'
# FZF configs
eval "$(fzf --zsh)"

# -- use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --no-ignore --strip-cwd-prefix --exclude .git"
_fzf_compgen_path() {
  fd --hidden --no-ignore --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --no-ignore --exclude .git . "$1"
}

FZF_GIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf-git.sh"
[ ! -d $FZF_GIT_HOME ] && mkdir -p "$(dirname $FZF_GIT_HOME)"
[ ! -d $FZF_GIT_HOME/.git ] && git clone https://github.com/junegunn/fzf-git.sh.git "$FZF_GIT_HOME"
source "${FZF_GIT_HOME}/fzf-git.sh"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {}'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf --preview 'eza --tree --color=always {}' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "--preview 'bat -n --color=always {}'" "$@" ;;
  esac
}
# End fzf config

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -U compinit && compinit

zinit cdreplay -q

bindkey '^ '  autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100
SAVEHIST=100
HITSDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey -e

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -laH --icons --color=always --tree --no-permissions --no-user --no-time --no-filesize $realpath'
# End of lines configured by zsh-newuser-install
export PATH="$HOME/.local/bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit/zinit.git" && command chmod g-rwX "$HOME/.local/share/zinit/zinit.git"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



source /usr/share/nvm/init-nvm.sh
# zoxide config
eval "$(zoxide init zsh)"

alias dotfiles='/usr/sbin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias ls="eza --color=always -laH --git --icons=always"
alias cd="z"
