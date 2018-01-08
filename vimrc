"
" Vim for CS 2XX - A Starter Configuration
" ========================================
"
" Further Reading:
" https://github.com/amix/vimrc/
" https://github.com/spf13/spf13-vim/blob/3.0/.vimrc
" https://stevelosh.com/blog/2010/09/coming-home-to-vim/
" http://items.sjbach.com/319/configuring-vim-right
" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
" http://www.alexeyshmalko.com/2014/using-vim-as-c-cpp-ide/

" For more information on anything in this file, enter
"   :help [thing you want info about]

" Highlight a line below and press Space (or 'za') in Normal mode to fold and
" unfold sections of this file. 'zR' to open everything.

" === Boilerplate === {{{

if &compatible
    set nocompatible          " Break backwards compatibility with vi
    " Needs to be set first, as has effects on other settings
endif

set t_Co=256
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

" }}}

" === Plugin Installation === {{{

" Install plugins using Pathogen 
" For more information: https://github.com/tpope/vim-pathogen

execute pathogen#infect()
call pathogen#helptags()

" To install your own plugins:
" In the terminal, go to ~/.vim/bundle
" Run "git clone [url of the plugin]"
" Restart Vim. That's it!

" The following plugins should now be installed:
"
" -- Interface Extensions --
"
" Undotree:
" Vim stores your undo history in a tree structure; this plugin lets you see it
" Open and close undo sidebar with
"   :UndotreeToggle
" https://github.com/mbbill/undotree
"
" VimPeekaboo:
" Instead of using a clipboard, Vim stores previously copied, cut, and deleted
" text in registers. This plugin shows you what's currently in the registers
" when you type " or @ in normal mode
" https://github.com/junegunn/vim-peekaboo
"
" VimGitgutter:
" If this file is in a git repository, adds symbols to lines that have been
" added, changed, or removed since the last commit.
" https://github.com/airblade/vim-gitgutter
"
" CtrlP:
" Open files more quickly by hitting Ctrl-p and typing the name of the file
" Also keeps track of recently used files
" https://github.com/ctrlpvim/ctrlp.vim
"
" NERDTree:
" Sidebar with a list of files in the current directory
" Open with :NERDTreeToggle or (custom mapping) \t
" https://github.com/scrooloose/nerdtree
"
" -- Coding Helpers --
"
" Syntastic:
" Check your code files for correct syntax on save
" https://github.com/vim-syntastic/syntastic
"
" Clang_Complete:
" Use the Clang compiler to provide autocompletion options for C and C++
" https://github.com/Rip-Rip/clang_complete
"
" VimCompletesMe:
" A more intuitive set of keybindings for Vim's autocompletion features
" While typing, press Tab to open the autocompletion menu
" Keep pressing Tab to cycle through the options
" https://github.com/ajh17/VimCompletesMe
"
" -- Syntax Highlighting --
"
" Vim Syntax X86 Objdump:
" Syntax highlighting for the output of your objdumps
" Make sure you save these files with the .dis extension
" https://github.com/shiracamus/vim-syntax-x86-objdump-d
"
" VimY86Syntax:
" Syntax highlighting for .ya and .ys files
" I wrote this one! Let me know if you find any bugs.
" https://github.com/wilt00/vim-y86-syntax
"
" -- Bonus Keybindings --
"
" VimRepeat:
" The . key repeats the last thing you did. This plugin lets you repeat plugin
" commands as well as native Vim ones.
" https://github.com/tpope/vim-repeat
"
" VimSurround:
" Plugin for surrounding text with quotes, brackets, etc. See help for usage.
" https://github.com/tpope/vim-surround
"
" VimCommentary:
" Toggle a comment on a line with gcc in Normal mode
" Toggle comments on a block with gc in Visual mode or gcgc in Normal mode
" https://github.com/tpope/vim-commentary
"
" Tabular:
" Align text by character using the :Tabularize command. See help for usage.
" https://github.com/godlygeek/tabular
"
" Nextval:
" Increment or decrement the number or boolean under your cursor with Ctrl-A
" and Ctrl-X, respectively
" https://github.com/vim-scripts/nextval
"
" -- Colors --
"
" Lightline:
" Add a pretty status bar to the bottom of the window
" https://github.com/itchyny/lightline.vim
"
" VimColorschemes:
" Just adds a ton of colorschemes. Run :colorscheme to see them all.
" https://github.com/flazz/vim-colorschemes
"
" Molokai:
" Another good colorscheme, based on the default from Sublime Text
" The default for this starter pack
" https://github.com/tomasr/molokai

" }}}

" === General Settings === {{{

set exrc                   " Vim will read settings from .vimrc files in project directories
set secure                 " exrc is a security hole; this prevents insecure commands

if !exists("g:syntax_on")  " Prevent unnecessary execution when sourcing this file
    syntax enable          " Always 'syntax enable', never 'syntax on'
endif
" set background=dark      " Colorscheme should set this
set synmaxcol=200          " For speed, apply syntax highlighting to only 1st 200 chars of line

set mouse=a                " Enable mouse
" Note that enabling mouse is incompatible with right-click pasting on Windows
" Also: right click pasting on Windows executes characters as vim commands if not already in insert mode

set modelines=0           " Turn off modelines for security reasons
set history=1000
set title                 " Set terminal title to open file

" Real-world tab default size is 8 spaces; respect this when reading tabs, but
" insert tabs as 4 spaces
set tabstop=8             " view tab as equivalent to 8 spaces
set softtabstop=4         " insert/delete 4 spaces when tab pressed / deleting tab
set expandtab             " makes tabs into spaces
set nojoinspaces          " prevent inserting two spaces after punctuation on join (J)
set shiftwidth=4          " set width for autoindents

" enable filetype-specific configuration
filetype plugin on
filetype indent on

" Prevent converting tabs to spaces for makefiles
autocmd FileType make setlocal noexpandtab

set number                " show line numbers
set showcmd               " displays last command entered in lower left
set showmode              " displays current mode at the bottom
set cursorline            " highlights current line

set scrolloff=5           " start scrolling when the cursor reaches n lines from the top/bottom 
set virtualedit=onemore   " allow cursor to go one character past last character of line

set wildmenu              " enables displaying alternative autocomplete options when using tab in command mode
set wildmode=list:longest " complete as much as possible
set lazyredraw            " speeds up execution by not redrawing screen when not necessary
set showmatch             " highlight matching [{(

set incsearch             " search as characters are entered
set hlsearch              " highlight search matches
set ignorecase            " case insensitive search
set smartcase             " except sometimes
set infercase             " and when doing tab completions

if v:version > 700        " These settings don't exist in Bert's version of Vim
    set undofile              " create <filename>.un~ on editing file; allows undo between sessions
    set undodir=~/.vim/undofiles,.
    " Write new undofiles to ~/.vim/undofiles; still reads from local directory if
    " you have any undofiles there

    set colorcolumn=81        " Highlight the 81st column, so you know when your line's too long
endif

autocmd FocusLost * :wa   " Saves file whenever vim window loses focus
set ruler                 " display line & column number in lower right

set wrap                  " Allow text to wrap
set showbreak=»»»         " prepend these characters to wrapped lines

" Display invisible characters using following substitutions
set listchars=tab:\ \ ,nbsp:_,trail:.
" autocmd FileType make setlocal listchars+=tab:>~
" That commented line is a bit of a hack; tab characters will be invisible
" until you open a makefile, and then they show up everywhere
set list

set backup                " Vim will create .swp files if your session crashes
" set backupdir=~/.vim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" set directory=~/.vim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim/tmp,~/.tmp,~/tmp
set directory=~/.vim/tmp,~/.tmp,~/tmp
" Prevent Vim from looking at global temp directories for backups
" The commented-out lines are a good idea on your personal computer, but in a
" shared environment like bertvm, probably not

" Vim will ignore files that look like these:
set wildignore+=*/.git/*,*/tmp/*,*.swp,*.o,*/.hg/*,*/.svn/*,*/.DS_Store,*~,*.pyc

set backspace=eol,start,indent  " indent:   allow backspacing over autoindent
                                " eol:      allow backspacing over linebreaks
                                " start:    allow backspacing over start of
                                "            insert
set noerrorbells

set foldenable            " enable code folding
set foldlevelstart=10     " open some folds by default. Set to 0 to close all by default, 99 to open all
set foldnestmax=10        " maximum of 10 nested folds
set foldmethod=syntax     " other options are: indent, marker, manual, expr, syntax, diff. For more, run :help foldmethod

" }}}

" === Keybindings === {{{

" By default, <leader> is \

" Remap jk to Escape, so you can use it to switch back to Normal mode
inoremap jk <ESC>

" Maps \<space> to unhighlight search results
nnoremap <leader><space> :nohlsearch<CR>

" Map space to open/close folds
nnoremap <space> za

" Inserts timestamp when pressing F5
nnoremap <F5> "=strftime("%c")<CR>P
inoremap <F5> <C-R>=strftime("%c")<CR>

" Force save when vim was opened without sudo privileges
" See https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
" cnoremap w!! w !sudo tee % >/dev/null
" We don't have sudo privileges here, but I thought this was still neat.

" In visual mode, move blocks of text up and down with <C-j> and <C-k>
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
" http://vim.wikia.com/wiki/Moving_lines_up_or_down

" Switch to newly created splits
nnoremap <C-w>v <C-w>v<C-w>w
nnoremap <C-w>s <C-w>s<C-w>w

" Swap functionality of Ctrl-backspace and C-w
" Ctrl-backspace to delete a word, because that's how Windows does it
inoremap  <C-w>
" C-w in insert mode switches to normal mode and awaits window command
inoremap <C-w> <ESC><C-w>

" }}}

" === AutoCmd === {{{

" Open quick fix menu after running :make
" https://gist.github.com/ajh17/a8f5f194079818b99199
autocmd QuickFixCmdPost * copen

" }}}

" === Controversial Settings === {{{

set hidden              " Allows Vim to open buffers in background

" }}}

" === Plugin-Specific Settings === {{{

" Necessary statusline options for Lightline
set laststatus=2        " Always show the statusline
set noshowmode          " Don't show the modeline, this is included in lightline

" Configure lightline blocks
" See :help lightline for more options
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left':  [ [ 'mode', 'paste' ],
            \              [ 'readonly', 'filename', 'modified' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'syntastic': 'SyntasticStatuslineFlag'
            \ },
            \ }

" Enable Syntastic statusline display if Vim supports it
if v:version > 700
    call add(g:lightline.active.left, [ 'syntastic' ])
endif

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1               " Set to 0 to turn off popup error list
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Choose which flags Syntastic sends to GCC
let g:syntastic_c_compiler_options = "-Wall -Wextra"

colorscheme molokai
" colorscheme railscasts
" colorscheme autumnleaf " A nice light colorscheme
" colorscheme iceman

" Tell Clang_Complete where to find Clang
let g:clang_library_path='/usr/local/clang+llvm-3.3-Ubuntu-13.04-x86_64-linux-gnu/lib'

set completeopt=menuone,preview

" Close Vim if NERDTree is the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle the NERDTree file sidebar with \f
nnoremap <leader>f :NERDTreeToggle<CR>

" }}}

" === Vimscript FileType Settings === {{{
augroup filetype_vim
    "autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    " That's what all those curly braces are for!
    autocmd FileType vim setlocal foldlevel=0
    autocmd FileType vim setlocal foldlevelstart=0
augroup END
" }}}

