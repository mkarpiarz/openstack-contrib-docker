syntax on

set tabstop=4
set shiftwidth=4
set expandtab

set spell
" underline as the spell check highlighter
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=red

" 50 characters in commit message title
syn match   gitcommitSummary    "^.\{0,50\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell

" 72 character wrap (fits inside Gerrit's message viewer)
"set textwidth=72
autocmd FileType gitcommit setlocal textwidth=72

set formatoptions+=t
