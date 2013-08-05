" The following copied from Arch Linux's /etc/vimrc
set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Extra options added in addition to the Arch Linux defaults
set tabstop=4          " 4 space indent
set shiftwidth=4
set expandtab          " Tabs to spaces
set hlsearch           " Highlight all matches of the current search
set pastetoggle=<F10>  " Toggle paste insert mode with F10
syntax on
filetype on
filetype plugin on

" Avoid potential modeline vulnerabilities
set nomodeline

" Map r to the sequence needed to replace the current selection with the buffer
vmap r "_dP

" Show unwanted whitespace
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces#Using_the_list_and_listchars_options
set list listchars=tab:>-,trail:.,extends:>

" Return to last edit position when opening files
" http://stackoverflow.com/a/14449484/1905196
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
