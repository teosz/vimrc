set nocompatible
set backspace=indent,eol,start
set autoindent
set ruler showcmd
set hls ic is
set showmatch
set bg=dark
set number
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set mouse=a
set smartindent
syntax on

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'embear/vim-localvimrc'
Bundle 'msanders/cocoa.vim'
Bundle 'DHowett/theos', { 'rtp': 'extras/vim/' }
Bundle 'scrooloose/syntastic'
Bundle 'Nemo157/glsl.vim'
if has("ruby")
    Bundle 'git://git.wincent.com/command-t.git'
endif
if v:version >= 703 && has("patch584") && has("python")
    Bundle 'Valloric/YouCompleteMe'
else
    function! TabOrComplete()
        if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
            return "\<C-N>"
        else
            return "\<Tab>"
        endif
    endfunction
    inoremap <Tab> <C-R>=TabOrComplete()<CR>
endif
filetype plugin indent on

set expandtab
set shiftwidth=4
set tabstop=4
au FileType *       setlocal expandtab   | setlocal tabstop=4 | setlocal shiftwidth=4
au FileType python  setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType lua     setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType cmake   setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType make    setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4

au BufNewFile,BufRead *.xm\|*.xmm  setlocal filetype=logos
au BufNewFile,BufRead *.vsh\|*.fsh setlocal filetype=glsl

map <F1> 1<C-w>w
map <F2> 2<C-w>w
map <F3> 3<C-w>w
map <F4> 4<C-w>w
map <F5> 5<C-w>w
map <F6> 6<C-w>w
map <F7> 7<C-w>w
map <F8> 8<C-w>w

command W w !sudo tee % > /dev/null

if has("unix")
    if system("echo -n \"$(uname)\"") == "Darwin"
        vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
        nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
    else
        vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<Return><CR>
        nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
    endif
endif
imap <C-v> <Esc><C-v>a

set completeopt=menu,menuone,longest
set pumheight=15
highlight Pmenu ctermfg=255
set updatetime=500
map <Leader>c :YcmForceCompileAndDiagnostics<CR>

if !has("gui_running")
    if has("win32unix")
        nmap <C-@> <C-Space>
        imap <C-@> <C-Space>
    else
        nmap <Nul> <C-Space>
        imap <Nul> <C-Space>
    endif
else
    colorscheme Tomorrow-Night
endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <Leader>t :NERDTreeToggle<CR>

set wildignore+=*.o,*.obj,.git,*build*,*.dylib,*.a
map <C-p><C-p> :CommandT<CR>
map <C-p><C-o> :CommandTBuffer<CR>
map <C-p><C-r> :CommandTFlush<CR>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

imap <C-h> <left>
imap <C-j> <down>
imap <C-k> <up>
imap <C-l> <right>
imap <C-o> <Return>

function! CompileOrLint()
endfunction

function! MakeAndRun()
    w
    if !empty(matchstr(getline(1), "^#!")) || (&ft == "sh")
        silent !chmod +x %
        ! time %
    elseif &ft == "python"
        let mainpy = findfile("__main__.py", expand("%:p:h") . ";")
        if empty(mainpy)
            !python %
        else
            execute "!python " . fnamemodify(mainpy, ":p:h") 
        endif
    else
        let mkf = findfile("Makefile", expand("%:p:h") . ";")
        if empty(mkf)
            if &ft == "c"
                !cc -Wall -W -lm -g %:p -o %:p:r && time %:p:r
            elseif &ft == "cpp"
                !c++ -Wall -W -lm -g %:p -o %:p:r && time %:p:r
            endif
        else
            execute "! cd " . fnamemodify(mkf, ":p:h") . " && make -j2"
        endif
    endif
endfunction

command! MakeAndRun call MakeAndRun()
map <F9> :MakeAndRun<CR>

function! SetUpPlugins()
    !cd ~/.vim/ruby/command-t && ruby extconf.rb && make
    "TODO: youcompleteme
endfunction
command! SetUpPlugins call SetUpPlugins()

