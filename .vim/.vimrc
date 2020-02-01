call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
"Plug 'itchyny/lightline.vim'
Plug 'junegunn/gv.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/conflict-marker.vim'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'rhysd/clever-f.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set termguicolors
set background=dark
colorscheme everset

let mapleader = " "

" hide unsaved buffers instead of force writing when they are unfocused
set hidden

" tsserver (coc.nvim) has issues with backups
set nobackup
set nowritebackup

set updatetime=300

set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <leader>rn <Plug>(coc-rename)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Better movement between buffer in Vim
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Show line numbers. Make them relative.
set number
set relativenumber

" No annoying sound on errors
set belloff=all

" Disable swapfile
set noswapfile

" normalize split direction
set splitbelow
set splitright

nnoremap <leader>t :CocCommand explorer
  \ --toggle
  \ --sources=buffer+,file+
  \ --file-columns=git:selection:clip:diagnosticError:indent:icon:filename;fullpath;size;modified;readonly<Cr>
nnoremap <leader>pf :CocList files<Cr>
nnoremap <leader>pg :CocList grep<Cr>
nnoremap <leader>pb :CocList buffers<Cr>
nnoremap <leader>pc :CocList commits<Cr>
nnoremap <leader>py :CocList yanks<Cr>

set laststatus=2

" lightline
let g:lightline = {
  \ 'colorscheme': 'dogrun',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'git', 'ctrlpmark', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \   'gitbranch': 'fugitive#head'
  \ }
\ }

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

" Tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Show highlight groups for current word
nmap <C-S-p> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

set path+=**
set wildmenu
