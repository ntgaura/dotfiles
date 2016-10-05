" ---------------------------- Encodings
set encoding=utf-8
scriptencoding utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp932,sjis,euc-jp

" -------------------------------- dein.vim
let s:vim_dir = $HOME . '/.vim'
let s:dein_dir = s:vim_dir . '/dein'
let s:dein_repo_name = 'Shougo/dein.vim'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/' . s:dein_repo_name

" Check dein has been installed or not.
if ! isdirectory(s:dein_repo_dir)
    echo "dein is not installed, install now."
    let s:dein_repo = "https://github.com/" . s:dein_repo_name
    echo "git clone " . s:dein_repo . " " . s:dein_repo_dir
    call system("git clone " . s:dein_repo . " " . s:dein_repo_dir)
endif

let &runtimepath = &runtimepath . "," . s:dein_repo_dir

if dein#load_state(expand(s:dein_dir))
    call dein#begin(expand(s:dein_dir), [$MYVIMRC, expand($SETTINGS_ROOT . '/.vimrc')])

    " ------------------------- System Plugin
    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/vimproc', {'build' : 'make'})
    call dein#add('vim-jp/vital.vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('tyru/open-browser.vim')
    if has('clientserver')
        call dein#add('thinca/vim-singleton')
    endif

    " ------------------------- Operation Utility
    call dein#add('Shougo/unite.vim')
    call dein#add('thinca/vim-quickrun')
    call dein#add('AndrewRadev/switch.vim')
    call dein#add('terryma/vim-expand-region')

    " ------------------------- Visualize
    call dein#add('mhinz/vim-startify')
    call dein#add('itchyny/lightline.vim')
    call dein#add('osyo-manga/vim-watchdogs')
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#add('bronson/vim-trailing-whitespace')

    " ------------------------- Tool
    call dein#add('Shougo/vimfiler')
    call dein#add('mattn/gist-vim')
    call dein#add('tpope/vim-fugitive')
    call dein#add('embear/vim-localvimrc')
    call dein#add('itchyny/vim-cursorword')

    " ------------------------- Text Object
    call dein#add('kana/vim-textobj-user')
    call dein#add('kana/vim-textobj-function')
    call dein#add('kana/vim-textobj-entire')
    call dein#add('osyo-manga/vim-textobj-multiblock')
    call dein#add('sgur/vim-textobj-parameter')
    call dein#add('mattn/vim-textobj-url')
    call dein#add('thinca/vim-textobj-comment')
    call dein#add('nelstrom/vim-textobj-rubyblock')
    call dein#add('deris/vim-textobj-enclosedsyntax')

    " ------------------------- Color Scheme
    call dein#add('29decibel/codeschool-vim-theme')

    call dein#end()
    call dein#save_state()
endif

if dein#check_install(['Shougo/vimproc'])
    call dein#install(['Shougo/vimproc'])
endif

if dein#check_install()
    call dein#install()
endif

" ---------------------------- my-augroup
augroup my_augroup
    autocmd!
augroup END

command! -bang -nargs=* MyAutocmd autocmd<bang> my_augroup <args>

" ---------------------------- singleton
if has('clientserver')
    call singleton#enable()
endif

" ---------------------------- Module Importing
let s:VITAL = vital#of('vital')
let s:List = s:VITAL.import('Data.List')

" ---------------------------- Color Scheme
syntax on
set background=dark
colorscheme codeschool

MyAutocmd ColorScheme * highlight CrLf term=underline ctermbg=DarkGreen guibg=DarkGreen
MyAutocmd VimEnter,WinEnter,BufWinEnter,BufNew * match CrLf /\r\n/

" ---------------------------- Folding
if has ('folding')
    set foldenable
    set foldmethod=marker
    set foldmarker={{{,}}}
    set foldcolumn=0
endif

" ---------------------------- Leader
let maplocalleader = ' '
let mapleader = ' '

" ---------------------------- Option Settings
filetype plugin indent on
set fileformat=unix
set fileformats=unix,dos
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set showcmd
set number
set showmatch
set matchtime=1
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nocindent
set smartindent
set ruler
set clipboard=unnamedplus
set noswapfile
set nobackup
set writebackup
set backupcopy=yes
set viminfo+=!
set cinoptions+=:0,g0
set showtabline=2
set previewheight=40
set splitbelow
set splitright
set noequalalways
set scrolloff=5
set nofoldenable
set formatoptions=jq
set laststatus=2
set t_Co=256
set directory-=.
set undodir=$HOME/.vim/undo
set display=lastline
set pumheight=10

" ---------------------------- Auto Command

" create directory automatically
function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction
MyAutocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

" autoreload .vimrc
MyAutocmd BufWritePost .vimrc source $MYVIMRC

" ruby settings
MyAutocmd BufNewFile,BufRead *.mpig setf ruby
MyAutocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 expandtab

" js settings
MyAutocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab

" pig settings
MyAutocmd BufNewFile,BufRead *.tpig setf pig
MyAutocmd FileType pig setlocal shiftwidth=4 softtabstop=4 expandtab textwidth=80
MyAutocmd FileType pig syntax sync minlines=500 maxlines=1000

" lua settings
MyAutocmd FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab

" markdown settings
MyAutocmd BufRead,BufNewFile *.mkd set filetype=markdown
MyAutocmd BufRead,BufNewFile *.md set filetype=markdown

" ActionScript settings
MyAutocmd BufRead,BufNewFile *.as set filetype=javascript

" json settings
MyAutocmd FileType json setlocal conceallevel=0

" TeX settings
let g:tex_conceal=''

" ---------------------------- keymap
nnoremap z .
nnoremap . z
nnoremap ; :
nnoremap % :%
inoremap <C-;> <Esc>

nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-i> :vertical resize +10<Cr>

nnoremap <Leader>j <C-w>J
nnoremap <Leader>k <C-w>K
nnoremap <Leader>h <C-w>H
nnoremap <Leader>l <C-w>L

nnoremap <Leader>r :QuickRun<Cr>
nnoremap <Cr> <C-]>

nnoremap <ESC><ESC> :nohlsearch<Cr>

nnoremap cd :lcd %:p:h<Cr>
nnoremap eh :e %:p:r.h<Cr>
nnoremap ec :e %:p:r.c<Cr>
nnoremap ep :e %:p:r.cpp<Cr>

nnoremap gf<Cr> gf
nnoremap gfv :<C-u>vsplit<Cr>gf
nnoremap gfs :<C-u>split<Cr>gf

nnoremap <silent> er :e $SETTINGS_ROOT/.vimrc<Cr>:lcd %:p:h<Cr>

function! s:cyclic_open(files)
    let l:user_ss_opt = &shellslash
    set shellslash

    let l:modified = map(a:files, 'fnamemodify(v:val, ":p")')
    let l:idx = s:List.find_index(l:modified, 'v:val == expand("%:p")')
    let l:path = l:modified[(l:idx + 1) % len(l:modified)]
    if l:idx == -1
        execute "vnew " . l:path
    else
        execute "e " . l:path
    endif

    let &shellslash = user_ss_opt
endfunction

nnoremap <silent> ew :call <SID>cyclic_open([
\    $SYNC_WORKDIR . "activity.md",
\    $SYNC_WORKDIR . "writing.md"
\])<Cr>

nnoremap qq <Esc>:q<Cr>

nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<Cr>:tabmove<Cr>
nnoremap <silent> <C-tab> :<C-u>tabnext<Cr>
nnoremap <silent> <C-S-tab> :<C-u>tabprevious<Cr>
nnoremap <silent> tl :<C-u>tabnext<Cr>
nnoremap <silent> th :<C-u>tabprevious<Cr>

nnoremap <silent> sn :cnext<Cr>
nnoremap <silent> sp :cprevious<Cr>

nnoremap <Leader>e :e ++enc=

nnoremap + <C-a>
nnoremap - <C-x>

vmap v <Plug>(expand_region_expand)
vmap <S-v> <Plug>(expand_region_shrink)

command!
\   -nargs=* -complete=mapping
\   AllMaps
\   map <args> | map! <args> | lmap <args>


" ----------------------------
" plugins
" ----------------------------

" ---------------------------- quickrun
let g:quickrun_config = {
\   'haskell': {
\       'command' : 'stack',
\       'cmdopt' : 'runghc',
\   },
\}


" ---------------------------- markdown
let g:markdown_fenced_languages = [
\   'css',
\   'erb=eruby',
\   'javascript',
\   'js=javascript',
\   'json=javascript',
\   'ruby',
\   'sass',
\   'xml',
\   'c',
\   'cpp',
\]

" ---------------------------- indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_space_guides = 1

" ---------------------------- gist
let g:gist_use_password_in_gitconfig = 1


" ---------------------------- textobj-multiblock
let g:textobj_multiblock_blocks = [
\   [ '(', ')' ],
\   [ '[', ']' ],
\   [ '{', '}' ],
\   [ '<', '>', 1 ],
\   [ '"', '"', 1 ],
\   [ "'", "'", 1 ],
\   [ "_", "_", 1 ],
\   [ "【", "】" ],
\   [ "「", "」" ],
\   [ "『", "』" ],
\]

" ---------------------------- expand-region
let g:expand_region_text_object = {
\   "\<Plug>(textobj-url-i)": 0,
\   "\<Plug>(textobj-url-a)": 0,
\   "\<Plug>(textobj-comment-i)": 0,
\   "\<Plug>(textobj-comment-a)": 0,
\   "\<Plug>(textobj-rubyblock-i)": 1,
\   "\<Plug>(textobj-rubyblock-a)": 1,
\   "\<Plug>(textobj-enclosedsyntax-i)": 1,
\   "\<Plug>(textobj-enclosedsyntax-a)": 1,
\   "\<Plug>(textobj-multiblock-i)": 1,
\   "\<Plug>(textobj-multiblock-a)": 1,
\   "\<Plug>(textobj-function-i)": 1,
\   "\<Plug>(textobj-function-a)": 1,
\}


" ---------------------------- lightline
let g:lightline = {
\   'colorscheme': 'Tomorrow_Night',
\   'separator': { 'left': '', 'right': '' },
\   'subseparator': { 'left': '', 'right': '' },
\   'active': {
\       'left': [ ['mode', 'paste'], ['fugitive', 'fileencoding', 'readonly', 'filename'] ],
\       'right': [ ],
\   },
\   'component_function': {
\       'mode': 'LightlineMode',
\       'modified': 'LightlineModified',
\       'readonly': 'LightlineReadonly',
\       'fugitive': 'LightlineFugitive',
\       'filename': 'LightlineFilename',
\       'fileformat': 'LightlineFileformat',
\       'filetype': 'LightlineFiletype',
\       'fileencoding': 'LightlineFileencoding',
\   },
\}
let g:lightline.inactive = g:lightline.active

if !has('gui_running')
    let g:lightline.separator = { 'left': '', 'right': '' }
    let g:lightline.subseparator = { 'left': '|', 'right': '|' }
endif

function! LightlineMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineModified()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
    return &ft !~? 'help\|vimfiler' && &readonly ? '[ReadOnly]' : ''
endfunction

function! LightlineFugitive()
    try
        if &ft !~? 'vimfiler' && exists('*fugitive#head')
            let _ = fugitive#head()
            let icon = has('gui_running') ? '' : ''
            return strlen(_) ? icon . fugitive#head() : ''
        endif
    catch
    endtry
    return ''
endfunction

function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \  '' != expand('%:.') ? expand('%:.') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '') .
        \ (' (' . line('.') . '/' . line('$') . ' : ' . col('.') . ')')
endfunction

function! LightlineFileformat()
    return winwidth(0) > 70 ?
        \ &fileformat == 'unix' ? 'unix/LF' :
        \ &fileformat == 'dos' ? 'dos/CRLF' :
        \ &fileformat == 'mac' ? 'mac/CR' :
        \ &fileformat : ''
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
    return winwidth(0) > 70 ? LightlineFiletype() . ' of ' . (strlen(&fenc) ? &fenc : &enc) . '(' . LightlineFileformat() . ')' : ''
endfunction

call lightline#init()
call lightline#colorscheme()
call lightline#update()

" ------------------------------------------------ gvim settings
function! GuiSettings()
    set guioptions-=e
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set guioptions-=T
    set guioptions+=a
    set guioptions+=i

    set background=dark
    colorscheme codeschool
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()

    " ---------------------------- Fonts
    set guifont=Ricty_for_Powerline:h12
    set guifontwide=Ricty_for_Powerline:h12
    set renderoptions=type:directx

    set linespace=1

    " ---------------------------- Ambiwidth
    if exists('&ambiwidth')
        set ambiwidth=double
    endif

    " ---------------------------- GVim Width&Height
    set lines=40
    set columns=140

    " ---------------------------- Screen mode
    set transparency=200

    if has('kaoriya')
        let g:isFullScreen = 0

        function! ToggleScreen()
            if g:isFullScreen
                ScreenMode 0
                let g:isFullScreen = 0
            else
                ScreenMode 5
                let g:isFullScreen = 1
            end
        endfunction
    endif

    nnoremap <C-Space> :call ToggleScreen()<Cr>
endfunction

MyAutocmd GUIEnter * call GuiSettings()
