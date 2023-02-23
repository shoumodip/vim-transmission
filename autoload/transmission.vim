function! transmission#open()
    edit *transmission*
    setlocal nomodifiable buftype=nofile

    noremap <buffer> <silent> a :call transmission#append()<cr>
    noremap <buffer> <silent> x :call transmission#remove()<cr>
    noremap <buffer> <silent> r :call transmission#update()<cr>

    call transmission#update()
    echo "Press 'a' to add torrent, 'x' to remove torrent, and 'r' to refresh"
endfunction

function! transmission#append()
    let file = input("File: ", "", "file")
    if file != ""
        call system("transmission-remote -a " . shellescape(file) . "")
        call transmission#update()
    endif
endfunction

function! transmission#remove()
    if line(".") > 1
        call system("transmission-remote -t " . split(getline("."), " ")[0] . " -r")
        call transmission#update()
    endif
endfunction

function! transmission#update()
    if !system("pgrep -x transmission-da")
        call system("transmission-daemon")
        sleep 100m
    endif

    setlocal modifiable
    silent! call deletebufline(".", 1, "$")
    silent! call setline(1, systemlist("transmission-remote -l")[:-2])
    setlocal nomodifiable
endfunction
