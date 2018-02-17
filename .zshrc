# ------------------------- zplug plugins
source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build: "zplug --self-manage"
zplug "themes/ys", from:oh-my-zsh

zplug "Tarrasch/zsh-autoenv"
zplug "b4b4r07/cli-finder"
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/http_code", as:command, use:bin/http_code
zplug "paulirish/git-open", as:plugin
zplug "mollifier/anyframe"
zplug "supercrabtree/k"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zuxfoucault/colored-man-pages_mod"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf", frozen:1
zplug "b4b4r07/zsh-gomi", as:command, use:bin, on:junegunn/fzf-bin
zplug "cswl/zsh-rbenv"

export ENHANCD_DISABLE_HOME=1

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

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
function ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

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

function show_git() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status
    fi
}

function show_ls() {
    echo
    echo -e "\e[0;33m--- currrent dir ---\e[0m"
    ls
}

function show_ls_abbrev() {
    echo
    echo -e "\e[0;33m--- currrent dir ---\e[0m"
    ls_abbrev
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    show_git
    show_ls
    echo
    zle reset-prompt
    return 0
}
function chpwd() {
    show_git
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

# ------------------------- net-tools deprecation
net_tools_deprecated_message () {
  echo -n 'net-tools コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
}

arp () {
  net_tools_deprecated_message
  echo 'Use `ip n`'
}
ifconfig () {
  net_tools_deprecated_message
  echo 'Use `ip a`, `ip link`, `ip -s link`'
}
iptunnel () {
  net_tools_deprecated_message
  echo 'Use `ip tunnel`'
}
iwconfig () {
  echo -n 'iwconfig コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
  echo 'Use `iw`'
}
nameif () {
  net_tools_deprecated_message
  echo 'Use `ip link`, `ifrename`'
}
netstat () {
  net_tools_deprecated_message
  echo 'Use `ss`, `ip route` (for netstat -r), `ip -s link` (for netstat -i), `ip maddr` (for netstat -g)'
}
route () {
  net_tools_deprecated_message
  echo 'Use `ip r`'
}

# ------------------------- peco
function peco-git-hash {
    local targets="$( git log --oneline --branches )"
    if [ $#targets -gt 0 ]
    then
        echo $(echo "${targets}" | peco | awk '{print $1}' )
    fi
}

function peco-git-changed-files {
    local targets="$( git status --short )"
    if [ $#targets -gt 0 ]
    then
        echo $( echo "${targets}" | peco | awk '{print $2}' )
    fi
}

function peco-ls-dir {
    local targets="$( find . -maxdepth 1 -type d | sed -e 's;\./;;' )"
    if [ $#targets -gt 0 ]
    then
        echo $( echo "${targets}" | peco )
    fi
}

function peco-ls-img {
    local targets="$( find . -maxdepth 1 -type f | grep -E '\.(jpg|jpeg|png|bmp|tiff)$' | sed -e 's;\./;;' )"
    if [ $#targets -gt 0 ]
    then
        echo $( echo "${targets}" | peco )
    fi
}

function peco-ls-files {
    local targets="$( find . -maxdepth 1 -type f | sed -e 's;\./;;' )"
    if [ $#targets -gt 0 ]
    then
        echo $( echo "${targets}" | peco )
    fi
}

function peco-gibo {
    gibo -l | grep -v '=' | awk -F'[ \t]+' '{for (i=1; i <= NF; i++) print $i OFS }' | peco | xargs gibo > .gitignore
}

function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        cd ${selected_dir}
    fi
}

function peco-sbt-new() {
  local TEMPLATE=`curl https://github.com/foundweekends/giter8/wiki/giter8-templates -s | grep "\.g8<" | sed -e "s/</ /g" -e "s/>/ /g" | awk '{print $3}' | peco | head -n 1`
  if [[ -z "$TEMPLATE" ]]; then
    return
  fi
  sbt new $TEMPLATE
}

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection

alias -g @d='$(peco-ls-dir)'
alias -g @i='$(peco-ls-img)'
alias -g @f='$(peco-ls-files)'
alias -g @D='$(peco-git-changed-files)'

# ------------------------- alias
alias maketags="ctags --exclude=\".git*\" -R"
alias zshrc="${EDITOR} ${SETTINGS_ROOT}/.zshrc"
alias chsettings="cd ${SETTINGS_ROOT}"
alias pecodoc='godoc $(ghq list | peco) | less'
alias ghc='stack ghc --'
alias ghci='stack ghci --'
alias gcp='gcloud compute copy-files'
alias gsh='gcloud compute ssh'
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

# ------------------------- eval envs
eval "$(pyenv init - zsh)"
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"
source <(kubectl completion zsh)

# ------------------------- profiling
if (which zprof > /dev/null) ;then
  zprof | less
fi