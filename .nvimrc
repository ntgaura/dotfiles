" ---------------------------- Encodings
set encoding=utf-8
scriptencoding utf-8
set termencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932,sjis

" ---------------------------- Dein
if &compatible
  set nocompatible
endif

let &runtimepath .= ','.expand('~/.config/nvim/repos/github.com/Shougo/dein.vim')
if dein#load_state(expand('~/.config/nvim'))
  call dein#begin(expand('~/.config/nvim'))

  call dein#add(expand('~/.config/nvim/repos/github.com/Shougo/dein.vim'))

  call dein#add('thinca/vim-quickrun')
  call dein#add('Shougo/denite.nvim')
  call dein#add('lambdalisue/gina.vim')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('29decibel/codeschool-vim-theme')
  call dein#add('fatih/vim-go')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('itchyny/lightline.vim')
  call dein#add('dhruvasagar/vim-table-mode')
  call dein#add('w0rp/ale')
  call dein#add('kassio/neoterm')
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('yuki-ycino/fzf-preview.vim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('sebastianmarkow/deoplete-rust')
  call dein#add('rust-lang/rust.vim')
  call dein#add('lighttiger2505/gtags.vim')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif


" ---------------------------- my-augroup
augroup my_augroup
    autocmd!
augroup END

command! -bang -nargs=* MyAutocmd autocmd<bang> my_augroup <args>

" ---------------------------- Color Scheme
syntax on
set background=dark
colorscheme codeschool

" ---------------------------- Basic Settings
filetype plugin indent on
set fileformat=unix
set fileformats=unix,dos
set number
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamed
set nofoldenable
set sh=zsh

" ---------------------------- Leader
let mapleader = ' '

" ---------------------------- keymap
nnoremap qq <Esc>:q<Cr>
inoremap <C-;> <Esc>

nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

nnoremap <Leader>j <C-w>J
nnoremap <Leader>k <C-w>K
nnoremap <Leader>h <C-w>H
nnoremap <Leader>l <C-w>L

nnoremap <silent> er :e $SETTINGS_ROOT/.nvimrc<Cr>:lcd %:p:h<Cr>

nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<Cr>:tabmove<Cr>
nnoremap <silent> <C-tab> :<C-u>tabnext<Cr>
nnoremap <silent> <C-S-tab> :<C-u>tabprevious<Cr>
nnoremap <silent> tl :<C-u>tabnext<Cr>
nnoremap <silent> th :<C-u>tabprevious<Cr>
nnoremap <silent> tm :<C-u>tabnew<Cr>:terminal<Cr>

nnoremap <ESC><ESC> :nohlsearch<Cr>

nnoremap cd :lcd %:h<Cr>

tnoremap <silent> <C-j> <C-\><C-n>

" ---------------------------- functions

" create directory automatically
function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction

function! s:detect_trailing_space()
    " detect trailing spaces for :write hook

    " search trailing spaces. wrap search and do not move cursor
    if search('\s\+$', 'wn')
       echomsg("warn: detect trailing space in " . expand("%"))
    endif
endfunction

function! s:show_trailing_spaces()
    highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
    match TrailingSpaces /\s\+$/
endfunction

function! s:delete_trailing_spaces()
    " delete all trailing spaces
    let s:cursor = getpos(".")
    %substitute/\s\+$//ge
    call setpos(".", s:cursor)
endfunction


" ---------------------------- vim-table-mode

let g:table_mode_corner='|'


" ---------------------------- autocmd

MyAutocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)



" ---------------------------- quickrun

let g:quickrun_config = {}
let g:quickrun_config.cpp = {
      \ 'type': 'cpp',
      \ 'cmdopt': '-std=c++11'
      \ }

" ---------------------------- indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_space_guides = 1

" ---------------------------- deoplate
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#rust#racer_binary=$HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$HOME.'/src/github.com/rust-lang/rust/src'

" ---------------------------- rust.vim
let g:rustfmt_autosave = 1

" ---------------------------- fzf-preview
let g:fzf_preview_layout = 'vsplit new'
let g:fzf_preview_rate = 1.0

nnoremap <silent> <Leader>p :<C-u>ProjectFilesPreview<CR>
nnoremap <silent> <Leader>b :<C-u>BuffersPreview<CR>
nnoremap <silent> <Leader>m :<C-u>ProjectOldFilesPreview<CR>
nnoremap <silent> <Leader>M :<C-u>OldFilesPreview<CR>

" ---------------------------- vim-go
let g:go_fmt_command = "goimports"

" ---------------------------- gtags
let g:Gtags_Auto_Map = 0
let g:Gtags_OpenQuickfixWindow = 1

" Show definetion of function cousor word on quickfix
nmap <silent> <Leader>d :<C-u>exe("Gtags ".expand('<cword>'))<CR><C-w>H
" Show reference of cousor word on quickfix
nmap <silent> <Leader>f :<C-u>exe("Gtags -r ".expand('<cword>'))<CR><C-w>H

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

