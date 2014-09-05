"################################################
"# Compile local Vim
"################################################
"# this is for Centos 5 
"# shouldnt need the python26 stuff otherwise
"# make sure $HOME/bin is in $PATH
"################################################
"
"cd ~
"hg clone https://vim.googlecode.com/hg/ vim
"cd vim/src
"make clean
"export vi_cv_path_python=/usr/bin/python26; ./configure --enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.6/config --with-features=huge --prefix=$HOME/opt/vim
"make && make install
"mkdir -p $HOME/bin && cd $HOME/bin && ln -s $HOME/opt/vim/bin/vim
"
"##############################################
"# OSX Mavericks
"# to match python and ruby versions
"# using ports
"#
"  sudo port install ruby-build
"  sudo port install ruby
"  sudo port install vim +ruby20 +python27
"
" check vim ruby version using
" :ruby puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
" check sys ruby version using
" "ruby -v"
"
" check vim python version using
" :python import sys; print(sys.version)
" check sys python version using
" python -c "import sys; print(sys.version)"
"##############################################
"
"## may need this for PyLint
"sudo pip install ordereddict
"#
"################################################

" Pathogen load
filetype off

" install pathogen like
" mkdir -p ~/.vim/autoload ~/.vim/bundle; \
" curl -Sso ~/.vim/autoload/pathogen.vim \
"    -L https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on
syntax on

"Automatic reloading of .vimrc
 autocmd! bufwritepost .vimrc source %

" set leader 
" default \
" lots of folks map it to comma
let mapleader=","
set showcmd


" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.

set pastetoggle=<F2>

" this puts anything in unnamed buffer into star buffer
" seems easier/better to just yank to star buffer if needed
"set clipboard=unnamed


" Mouse and backspace
"set mouse=a " on OSX press ALT and click
"" set bs=2 " make backspace behave like normal again


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" map sort function to a key
vnoremap <Leader>s :sort<CR>


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
"autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
"au InsertLeave * match ExtraWhitespace /\s\+$/

" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
"set nobackup
"set nowritebackup
"set noswapfile

" load templates when we edit a new script
function! LoadTemplate()
  silent! 0r ~/.vim/skel/tmpl.%:e
  " Highlight %VAR% placeholders with the Todo colour group
  syn match Todo "%\u\+%" containedIn=ALL
endfunction
autocmd! BufNewFile * call LoadTemplate()
"Jump between %VAR% placeholders in Normal mode with <Ctrl-p>
nnoremap <c-p> /%\u.\{-1,}%<cr>c/%/e<cr>
"Jump between %VAR% placeholders in Insert mode with <Ctrl-p>
inoremap <c-p> <ESC>/%\u.\{-1,}%<cr>c/%/e<cr>


" Settings for python-mode
" cd ~/.vim/bundle
" git clone https://github.com/klen/python-mode
"
" for a particular version of python-mode
" (this is the last one to use PyLint)
" (later ones dont seem to work)
" git checkout 0.6.19
"
" debug
let g:pymode_debug=1
"
" Set default pymode python options
" this seems to turn on line numbers by default now
let g:pymode_options = 0
"
" Check code every save
let g:pymode_lint_write = 0
let g:pymode_lint_on_write = 0

" Skip errors and warnings
" " E.g. "E501,W002", "E2,W" (Skip all Warnings and Errors startswith E2) and
" line too long
let g:pymode_lint_ignore = "E501"

" Convert from 4 to 2 space indent
" change lines in ~.vim/bundle/python-mode/after/indent/python.vim
" setlocal tabstop=2
" setlocal softtabstop=2
" setlocal shiftwidth=2
"
" Pylint configuration file
" If file not found use 'pylintrc' from python-mode plugin directory
" seems to really use
" ~/.vim/bundle/python-mode/pylint.ini as default
"let g:pymode_lint_config = "/Users/johns/.vim/pylintrc"
let g:pymode_lint_config = "$HOME/workspace/ubiquity/pylintrc"
" Convert from 4 to 2 space indent in pylintrc like
" [FORMAT]
" # String used as indentation unit. This is usually " " (4 spaces) or "\t" (1
" # tab).
" indent-string='  '
" # Maximum number of characters on a single line.
" max-line-length=100
"
" ~/.vim/bundle/python-mode/pylibs/pylama/lint/pylama_pep8/pep8.py
" must be modified to support 2 spaces instead of four
" or exclude errors E111 and E121, they are checked by pylint
"
"375,376c375,376
"<     if indent_char == ' ' and indent_level % 2:
"<         yield 0, "E111 indentation is not a multiple of two"
"---
">     if indent_char == ' ' and indent_level % 4:
">         yield 0, "E111 indentation is not a multiple of four"
"496,497c496,497
"<                 elif hang % 2:
"<                     error = "E121", "indentation is not a multiple of two"
"---
">                 elif hang % 4:
">                     error = "E121", "indentation is not a multiple of four"
"
"
" installing command-t to search for files to open
" cd ~/.vim
" git clone git://git.wincent.com/command-t.git bundle/command-t
" then complile the extension
" cd ~/.vim/bundle/command-t/ruby/command-t
" ruby extconf.rb
" make
if &term =~ "xterm" || &term =~ "screen"
    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif
"
" install gnupg.vim to edit encrypted files
" git clone https://github.com/jamessan/vim-gnupg.git bundle/vim-gnupg
let g:GPGPreferSymmetric = 1
