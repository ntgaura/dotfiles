# ------------------------- zplug plugins
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build: "zplug --self-manage"
zplug "themes/ys", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "b4b4r07/http_code", as:command, use:bin/http_code
zplug "paulirish/git-open", as:plugin
zplug "mollifier/anyframe"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zuxfoucault/colored-man-pages_mod"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf"
zplug "b4b4r07/zsh-gomi", as:command, use:bin, on:junegunn/fzf-bin

export ENHANCD_DISABLE_HOME=1

if [ ! ~/.zplug/last_zshrc_check_time -nt ${SETTINGS_ROOT}/.zshrc ]; then
    touch ~/.zplug/last_zshrc_check_time
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
fi

zplug load

# ------------------------- envs
export PATH="${PATH}:${HOME}/bin:${HOME}/.anyenv/bin:${HOME}/.cargo/bin:${HOME}/dotfiles/bin:${HOME_LOCAL}/bin"

# ------------------------- setopts

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_verify

# ------------------------- auto functions
function exa_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='exa'
    local -a opt_ls
    opt_ls=('-a' '-l' '--git' '--group' '--color=always')

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

function show_exa() {
    echo
    echo -e "\e[0;33m--- current dir ---\e[0m"
    exa -a -l --git --header --group
    echo
}

function show_ls_abbrev() {
    echo
    echo -e "\e[0;33m--- current dir ---\e[0m"
    exa_abbrev
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    show_exa
    echo
    zle reset-prompt
    return 0
}
function chpwd() {
    show_ls_abbrev
}
zle -N do_enter
bindkey '^m' do_enter

# neovimのterminalで使っているときカレントを自動的に移動
function neovim_autocd() {
  [[ $NVIM_LISTEN_ADDRESS ]] && ~/dotfiles/bin/neovim-autocd
}
chpwd_functions+=( neovim_autocd )

# ------------------------- rでR言語が起動するようにする
# http://qiita.com/awakia/items/3c5f6c536cb75ef20149
disable r

# ------------------------- peco
function peco-git-hash-insert {
  git log --oneline --branches \
    | anyframe-selector-auto \
    | awk '{print $1}' \
    | anyframe-action-insert
}
zle -N peco-git-hash-insert

function peco-git-changed-files-insert {
  git status --short \
    | anyframe-selector-auto \
    | awk '{print $2}' \
    | anyframe-action-insert
}
zle -N peco-git-changed-files-insert

function peco-ls-files-insert {
  find . -maxdepth 1 -type f \
    | sed -e 's;\./;;' \
    | anyframe-selector-auto \
    | anyframe-action-insert
}
zle -N peco-ls-files-insert

function peco-ls-dir-insert {
  find . -maxdepth 1 -type d \
    | sed -e 's;\./;;' \
    | anyframe-selector-auto \
    | anyframe-action-insert
}
zle -N peco-ls-dir-insert

function peco-sbt-new {
  curl https://github.com/foundweekends/giter8/wiki/giter8-templates -s \
    | grep "\.g8<" \
    | sed -e "s/</ /g" -e "s/>/ /g" \
    | awk '{print $3}' \
    | anyframe-selector-auto \
    | head -n 1 \
    | anyframe-action-execute sbt new
}
zle -N peco-sbt-new

function peco-ls-img {
  find . -maxdepth 1 -type f \
    | grep -E '\.(jpg|jpeg|png|bmp|tiff)$' \
    | sed -e 's;\./;;' \
    | anyframe-selector-auto \
    | anyframe-action-execute open
}
zle -N peco-ls-img


# ------------------------- alias
alias maketags="ctags --exclude=\".git*\" -R"
alias zshrc="${EDITOR} ${SETTINGS_ROOT}/.zshrc"
alias chsettings="cd ${SETTINGS_ROOT}"
alias pecodoc='godoc $(ghq list | peco) | less'
alias ghc='stack ghc --'
alias ghci='stack ghci --'
alias dkc='docker-compose'

# ------------------------- key-binding
bindkey "^k" up-line-or-history
bindkey "^j" down-line-or-history
bindkey '^R' peco-history-selection

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end

bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

bindkey '^gg' anyframe-widget-cd-ghq-repository
bindkey '^g^g' anyframe-widget-cd-ghq-repository
bindkey '^gb' anyframe-widget-checkout-git-branch
bindkey '^g^b' anyframe-widget-checkout-git-branch
bindkey '^gh' peco-git-hash-insert
bindkey '^g^h' peco-git-hash-insert
bindkey '^gf' peco-git-changed-files-insert
bindkey '^g^f' peco-git-changed-files-insert

bindkey '^e^k' anyframe-widget-kill
bindkey '^ek' anyframe-widget-kill

bindkey '^ff' peco-ls-files-insert
bindkey '^f^f' peco-ls-files-insert
bindkey '^fd' peco-ls-dir
bindkey '^f^d' peco-ls-dir

bindkey '^fn' peco-sbt-new
bindkey '^f^n' peco-sbt-new

# ------------------------- eval envs
if [ -x "$(command -v anyenv)" ]; then
  eval "$(anyenv init - zsh)"
fi
if [ -x "$(command -v direnv)" ]; then
  eval "$(direnv hook zsh)"
fi
# if [ -x "$(command -v kubectl)" ]; then
#   source <(kubectl completion zsh)
# fi

# ------------------------- profiling
if (which zprof > /dev/null) ;then
  zprof | less
fi
