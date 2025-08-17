" -----------------------------
" BASIC EDITOR SETTINGS
" -----------------------------
set number
set relativenumber
set tabstop=4 shiftwidth=4 expandtab
set smartindent
syntax on
set encoding=utf-8
filetype plugin indent on

" -----------------------------
" AUTOCOMPLETE BRACKETS & QUOTES
" -----------------------------
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>

" -----------------------------
" THEME & PLUGINS
" -----------------------------
call plug#begin('~/.vim/plugged')
Plug 'rebelot/kanagawa.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'neoclide/coc-snippets'
call plug#end()

" Set Kanagawa Dragon theme
colorscheme kanagawa-dragon

" -----------------------------
" RUN: <Space> + r (auto-detect by filetype: python, javascript, php, rust, c)
" -----------------------------
function! s:RunCurrentFile()
  write
  if &filetype ==# 'python'
    execute '!python3 %'
  elseif &filetype ==# 'javascript'
    execute '!node %'
  elseif &filetype ==# 'php'
    execute '!php %'
  elseif &filetype ==# 'rust'
    if filereadable('Cargo.toml')
      execute '!cargo run'
    else
      execute '!rustc % -o %:r && ./%:r'
    endif
  elseif &filetype ==# 'c'
    execute '!clang % -o %:r && ./%:r'
  else
    echo "No run command for filetype: " . &filetype
  endif
endfunction
nnoremap <SPACE>r :call <SID>RunCurrentFile()<CR>

" -----------------------------
" AUTOCOMPLETE + SNIPPETS
" -----------------------------
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Enable coc extensions
let g:coc_global_extensions = [
    \ 'coc-pyright',
    \ 'coc-snippets',
    \ 'coc-clangd',
    \ 'coc-tsserver',
    \ 'coc-phpls',
    \ 'coc-rust-analyzer'
    \ ]

" Point rust-analyzer to Termux binary (prevents download prompt)
let g:coc_user_config = {
      \ 'rust-analyzer.serverPath': '/data/data/com.termux/files/usr/bin/rust-analyzer'
      \ }

inoremap <silent> <C-l> <Plug>(coc-snippets-expand-jump)
inoremap <silent> <C-h> <Plug>(coc-snippets-prev)
inoremap <expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"

" -----------------------------
" TERMUX CLIPBOARD SHORTCUTS
" -----------------------------
" Copy visual selection to clipboard
vnoremap <leader>y :'<,'>w !termux-clipboard-set<CR><CR>

" Copy current line to clipboard
nnoremap <leader>yy :.w !termux-clipboard-set<CR><CR>

" Paste from system clipboard
" Normal mode: remap `p` to pull from termux clipboard
nnoremap p :call setreg('"', substitute(system('termux-clipboard-get'), '\n\+$', '', ''))<CR>p
" Insert mode: paste with Ctrl+P (doesn’t override text insertion `p`)
inoremap <C-p> <C-r>=substitute(system('termux-clipboard-get'), '\n\+$', '', '')<CR>

" -----------------------------
" AUTO YANK TO CLIPBOARD (yanks only, not deletes/changes)
" -----------------------------
augroup YankToClipboard
  autocmd!
  autocmd TextYankPost * if has('nvim') && get(v:event,'operator','') ==# 'y' |
        \ call system('termux-clipboard-set',
        \   getreg(get(v:event,'regname','') ==# '' ? '"' : get(v:event,'regname',''))) |
        \ endif
augroup END
