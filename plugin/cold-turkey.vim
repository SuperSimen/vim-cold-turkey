let s:counters = {}

function! s:MapMotion(command)
    execute "nnore <silent> " . a:command . " :call Move('" . a:command . "')<CR>"
endfunction

function! s:Map(Fun, list)
    if len(a:list) == 0
        return []
    else
        return [a:Fun(a:list[0])] + s:Map(a:Fun, a:list[1:])
    endif
endfunction

function! s:InitializaSettings()
    if !exists('g:coldturkey_motions')
        let g:coldturkey_motions = 'h,j,k,l'
    endif
    call s:Map(function('s:MapMotion'), split(g:coldturkey_motions, ','))
    if !exists('g:coldturkey_time_window')
        let g:coldturkey_time_window = 10
    endif
    if !exists('g:coldturkey_max_repeats')
        let g:coldturkey_max_repeats = 10
    endif
endfunction
call s:InitializaSettings()

function! Move(motion)
    if has_key(s:counters, a:motion)
        call s:UpdateCounter(a:motion, g:coldturkey_time_window)
    else
        call s:ResetCounter(a:motion)
    endif
    call s:MoveIfAllowed(a:motion, g:coldturkey_max_repeats)
endfunction

function! s:UpdateCounter(motion, timeout)
    let timer = s:counters[a:motion].timer
    if (localtime() - timer) >= a:timeout
        call s:ResetCounter(a:motion)
    else
        call s:IncrementCounter(a:motion)
    endif
endfunction

function! s:IncrementCounter(motion)
    let counter = s:counters[a:motion].counter
    let s:counters[a:motion].counter = counter + 1
endfunction

function! s:MoveIfAllowed(motion, maxRepeats)
    let counter = s:counters[a:motion].counter
    if counter < a:maxRepeats
        execute "normal! ".  a:motion
    endif
endfunction

function! s:ResetCounter(motion)
    let s:counters[a:motion] = {'counter': 1, 'timer': localtime()}
endfunction
