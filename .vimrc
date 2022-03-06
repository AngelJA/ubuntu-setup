" === plugins ===
" install plugin manager first if needed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vim-plug-plugins')

Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Konfekt/FastFold'
Plug 'AngelJA/vim-code-dark'
Plug 'vifm/vifm.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-airline/vim-airline'
Plug 'chrisbra/csv.vim'

call plug#end()

" git shortcuts
command GitAdd !git add -- %
cnoreabbrev ga GitAdd
command GitReset !git reset -- %
cnoreabbrev gr GitReset
command GitLog !git log -p -- %
cnoreabbrev gl GitLog
cnoreabbrev ag Ag
cnoreabbrev git !git

command! -bang GitLines call fzf#run(
            \fzf#wrap({
            \'sink': funcref('s:diff_sink'),
            \'source': 'git diff -U10 | gitdifflines | sed -n "/^.*:\x1b\[0;3\(1m-\|2m+\)/p"',
            \'options': [
                \'--ansi',
                \'--bind=ctrl-/:toggle-preview',
                \'--delimiter', ':',
                \'--preview', 'git diff -U10 -- {2} | sed 1,4d | bat -ldiff --color=always -p --highlight-line={1}',
                \'--preview-window', 'wrap,+{1}-/2',
                \'--reverse',
                \'--tiebreak', "index",
                \'--with-nth', '2..']}
            \),
        \<bang>0)

function! s:diff_sink(line)
    execute 'e +'.split(a:line, ':')[2].' '.split(a:line, ':')[1]
    execute 'normal zz'
endfunction

" fold diffs/patches
command FoldDiff setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)
function! DiffFold(lnum)
  let line = getline(a:lnum)
  if line[0] =~ '[-+?]'
    return 0
  else
    return 1
  endif
endfunction

" === general ===
set tabstop=4                       " number of spaces for a tab
set softtabstop=4
set shiftwidth=4                    " number of spaces for a < or >
set expandtab                       " turn tabs into spaces
set hlsearch                        " highlight hits when searching
set number                          " show line numbers
set relativenumber                  " show line numbers relative to cursor
set smartindent                     " better auto-indenting
set viewoptions-=curdir             " don't save buffer's curdir
set ttimeoutlen=5
" space toggles fold
nnoremap <space> za
set ignorecase                      " ignore case in search
set smartcase                       " unless there is a capital letter
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
set hidden                          " hide buffer when unloaded
set noro                            " don't open RO in vimdiff
set nofoldenable
set foldmethod=syntax
set nowrap
colorscheme codedark
set cot=menu,menuone,noinsert,popup
" cursor settings (enable block cursor in windows terminal)
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"
set mouse=a
set updatetime=100
set clipboard=unnamedplus
" highlight matches without moving cursor
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" search for selected text
vnoremap <C-_> y/\V<C-R>"<CR>

" === fzf ===
let g:fzf_layout = {'window': {'width':1, 'height':0.97, 'yoffset':0}}
nnoremap <silent> <C-F> :Ag <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent> <C-P> :Files<CR>
nnoremap <silent> <C-B> :Buffers<CR>
nnoremap <silent> <C-G> :GFiles?<CR>
nnoremap <silent> <C-H> :GitLines<CR>
nnoremap <silent> <C-T> :Tags<CR>

" === ALE ===
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> <C-K> :cbe<CR>
nnoremap <silent> <C-J> :caf<CR>
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> ga <Plug>(ale_go_to_type_definition)
nmap <silent> gr :ALEFindReferences<CR>
imap <silent> <C-K> <Plug>(ale_complete)
nmap <silent> K :ALEHover<CR>
let g:ale_set_highlights = 0
let g:ale_set_quickfix = 1
let g:airline_theme = 'codedark'
let g:airline_section_a = ""
let g:airline_section_b = ""
let g:airline_section_x = ""
let g:airline_section_y = ""
let g:airline_section_z = airline#section#create(['linenr', 'colnr'])
let g:airline#extensions#whitespace#enabled = 0
let g:ale_linters = {'python': ['pyright'], 'cpp': ['clangd', 'clangtidy']}
let g:ale_fixers = {'python': ['black'], 'cpp': ['clang-format']}
let g:ale_fix_on_save = 1
let g:ale_completion_autoimport = 0
let g:ale_floating_preview = 1
let g:ale_floating_window_border = []

" === filetype stuff ===
let g:xml_syntax_folding=1
autocmd FileType proto,pbtxt,cpp,json setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal foldmethod=indent

" === colors
set termguicolors

" Correct RGB escape codes for vim inside tmux
if !has('nvim') && $TERM ==# 'screen-256color'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" === git gutter
nmap ghp <Plug>(GitGutterPreviewHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghs <Plug>(GitGutterStageHunk)
xmap ghs <Plug>(GitGutterStageHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
