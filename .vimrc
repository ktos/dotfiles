set mouse-=a
syntax enable
set background=dark
colorscheme gruvbox

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Ctrl+s to save
map <C-s> :w<cr>
imap <C-s> <ESC>:w<cr>a

" Ctrl+q to exit
map <C-q> :q!<cr>
imap <C-q> <ESC>:q!<cr>
