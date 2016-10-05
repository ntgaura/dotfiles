# ------------------------- ensure installed oh-my-zsh
if [ ! -e "${ZSH}" ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ${ZSH}
fi

# ------------------------- oh-my-zsh settings
ZSH_THEME="ys"

plugins=(git ruby gem archlinux github rvm bundler python pyenv virtualenv)

source $ZSH/oh-my-zsh.sh


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

function pecogibo {
    gibo -l | grep -v '=' | awk -F'[ \t]+' '{for (i=1; i <= NF; i++) print $i OFS }' | peco | xargs gibo > .gitignore
}

alias -g @d='$(peco-ls-dir)'
alias -g @i='$(peco-ls-img)'
alias -g @f='$(peco-ls-files)'
alias -g @D='$(peco-git-changed-files)'

# ------------------------- alias
alias maketags="ctags --exclude=\".git*\" -R"
alias zshrc="${EDITOR} ${SETTINGS_ROOT}/.zshrc"
alias chsettings="cd ${SETTINGS_ROOT}"

# ------------------------- key-binding
bindkey "^k" up-line-or-history
bindkey "^j" down-line-or-history
