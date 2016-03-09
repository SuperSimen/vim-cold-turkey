
nnore <silent> h :call Move('h')<CR>
nnore <silent> j :call Move('j')<CR>
nnore <silent> k :call Move('k')<CR>
nnore <silent> l :call Move('l')<CR>

let s:counters = {}

let s:timeout = 10
let s:maxRepeats = 10

function! Move(direction)
    if has_key(s:counters, a:direction)
        let timer = s:counters[a:direction].timer
        if (localtime() - timer) >= s:timeout
            call s:ResetTimer(a:direction)
        else
            let counter = s:counters[a:direction].counter

            if counter >= s:maxRepeats
                return
            else
                let s:counters[a:direction].counter = counter + 1
            endif
        endif
    else
        call s:ResetTimer(a:direction)
    endif

    execute "normal! ".  a:direction
endfunction

function! s:ResetTimer(direction)
    let s:counters[a:direction] = {'counter': 1, 'timer': localtime()}
endfunction
