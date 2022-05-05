" enables this sorta IDE-ish mode. idk it's helpful sometimes
function IDEMode()
    NERDTree
    wincmd l
    bel sp | term
    resize -20
    wincmd k
endfunction

" :qa is awkward and i hate it
cmap qq qa

command Ide call IDEMode()

