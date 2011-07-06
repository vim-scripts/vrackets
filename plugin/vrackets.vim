" File:		vrackets.vim
" Author:	Gerardo Marset (gammer1994@gmail.com)
" Version:	0.1
" Description:	Automatically close/delete different kinds of brackets.

" You can modify this dictionary as you wish. Note however that quotation marks
" and other pairs in which the closing symbol is the same as the opening one
" won't work as expected (yet).
let s:match = {'(': ')',
              \'{': '}',
              \'[': ']',
              \'¡': '!',
              \'¿': '?'}

for [s:o, s:c] in items(s:match)
    execute 'ino <silent> ' . s:o . " <C-R>=VracketOpen('" . s:o . "')<CR>"
    execute 'ino <silent> ' . s:c . " <C-R>=VracketClose('" . s:o . "')<CR>"
endfor
inoremap <silent> <BS> <C-R>=VracketBackspace()<CR>

function! VracketOpen(bracket)
    let l:o = a:bracket
    let l:c = s:match[l:o]
    
    return l:o . l:c . "\<Left>"
endfunction

function! VracketClose(bracket)
    let l:c = s:match[a:bracket]

    if s:GetCharAt(0) == l:c
        return "\<Right>"
    endif
    return l:c
endfunction

function! VracketBackspace()
    let l:match = get(s:match, s:GetCharAt(-1), '')
    if l:match == '' || l:match != s:GetCharAt(0)
        return "\<BS>"
    endif
    return "\<Esc>2s"
endfunction

function! s:GetCharAt(...)
    " Super Dirty Function(tm).
    let l:n = a:0 ? a:1 : 0
    let l:im = @@
    let l:vi = &virtualedit
    set virtualedit=onemore

    if l:n == 0
        normal yl
    elseif l:n < 0
        execute 'normal ' . -l:n . 'h'
        normal yl
        execute 'normal ' . -l:n . 'l'
    else
        execute 'normal ' . l:n . 'l'
        normal yl
        execute 'normal ' . l:n . 'h'
    endif

    let l:char = @@
    let &virtualedit=l:vi
    let @@ = l:im
    return l:char
endfunction
