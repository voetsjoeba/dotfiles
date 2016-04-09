set t_Co=256                    " enable 256 colors
set background=dark             " brighter colors
set ignorecase                  " case insensitive search
set scs                         " ...except when the search string contains caps ('smart-case search')
set tabstop=4                   " tab size (as an amount of visual spaces)
set shiftwidth=4                " shiftwidth; size of a 'software' tabstop (used for >> and <<); should match value of 'ts'
set virtualedit=onemore         " allow for cursor to go beyond last character; useful to delete stuff at the end of lines without wrapping around or eating into lines
set history=999                 " store lots of history (default is 20)
set scrolloff=3                 " maintain at least X visible lines above and below the cursor
set smartcase
set nu                          " enable line numbers
set numberwidth=4               " line number gutter width
set modeline                    " enable mode lines (e.g. '# vim: x=y :' at the start of files)
set modelines=5                 " look at the first X lines in a file for modelines
set ffs=unix,dos,mac            " Use Unix as the standard file type
set textwidth=0 wrapmargin=0    " no automatic physical line wrapping please

syntax on                       " enable syntax highlighting
filetype plugin on              " auto-detect file types,
filetype indent off             " but don't auto-load their indentation rules if one is detected

set paste                       " this is what you want 95% of the time, so let's enable it by default
set pastetoggle=<F2>            " sane indentation on pastes
set laststatus=2                                        " always show the status line
set statusline=(%n)\ %<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P  " same as default status line, but with the full file path and buffer number (useful for vimdiff)

hi StatusLine cterm=bold                                 " un-invert the statusline colors ...
hi StatusLine ctermbg=black ctermfg=white                " ... so that these actually make sense
hi Comment    ctermfg=darkgrey
hi LineNr     ctermfg=darkgrey                           " prettier line numbers
hi Todo       term=standout cterm=bold ctermfg=0 ctermbg=121        " green TODO highlight
hi ModeMsg    cterm=bold ctermfg=white ctermbg=NONE      " always color the mode message (-- INSERT -- etc) white bold
"hi Comment    ctermfg=30                                " prettier comment colors (turquoise)

" in visual mode, don't deselect after indenting or de-denting with the > or < keys
" works as follows: restore the current selection ('gv') after indenting/dedenting ('>'); then additionally move the cursor one character
" along to the right resp. left ('l', 'h') to compensate for the added indentation char. (Without this correction, the cursor accumulates
" off-by-one cursor movements, eventually drifts off onto other lines and starts dragging them along).
" If expandtab is on, then our tab character gets inserted as <shiftwidth> spaces, so in that case we need to move <shiftwidth> times to the
" right/left instead of only once.
vnoremap <expr> >       &expandtab ? ">gv".&shiftwidth."l" : ">gvl"
vnoremap <expr> <       &expandtab ? "<gv".&shiftwidth."h" : "<gvh"
vnoremap <expr> <Tab>   &expandtab ? ">gv".&shiftwidth."l" : ">gvl"
vnoremap <expr> <S-Tab> &expandtab ? "<gv".&shiftwidth."h" : "<gvh"

" Automatically enable 'very-magic' search mode (i.e. extended regular expressions)
nnoremap / /\v
vnoremap / /\v

" make 'cc' apply the correct indentation on blank lines (normally it doesn't work because on a blank line there is no indentation, and 'cc' preserves that)
nnoremap cc i.<Esc>==S

nmap <F3> :set number! number?<cr>                       " toggle line numbers with F3
nmap <F4> :set list! list?<cr>                           " toggle visual whitespace characters with F4

" tweak the syntax rules and colors for YAML files
autocmd FileType yaml hi Comment ctermfg=darkgrey
autocmd FileType yaml hi Constant ctermfg=white
"autocmd FileType yaml hi Identifier ctermfg=cyan
"" correct allowed anchor/alias characters (original: syn match   yamlAnchor '&.\+')
"autocmd FileType yaml syn match   yamlAnchor    /&[^\[\]\{\}, \t]\+/
"autocmd FileType yaml syn match   yamlAlias     /\*[^\[\]\{\}, \t]\+/

" disable automatic word wrapping when editing git commit messages
autocmd Syntax gitcommit setlocal nowrap
autocmd Syntax gitcommit setlocal textwidth=0

" custom command for splitting up a line by newlines every 64 characters
" usage: :Pem64
" Note: the -range flag allows the command to take range of lines; with the '-range' syntax,
" the range defaults to the current line if not specified (as opposed to e.g. '-range=%', which
" will default to the entire file)
command -range Pem64 <line1>,<line2>s/\v(.{64})/\1^M/g
