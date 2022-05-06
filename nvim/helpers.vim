" makes the environment more like a workspace, for me anyway
function Workspace(...)
    set title
    let indicator_index = system("echo $RANDOM") % g:const_workspace_indicators_count
    let indicator = g:const_workspace_indicators[indicator_index]
    let workspace_title = indicator . " wkspce: "

    " only open NERDTree once for workspace activation
    if !exists("g:user_workspace_active")
        NERDTree
        wincmd l
    endif

    " default workspace title will show current directory
    if a:0
        let g:user_workspace_active = a:1
        let l:makefile_name = g:const_workspace_env_dir . "/" . a:1 . ".mk"
        let l:valid_env = filereadable(l:makefile_name)
    else
        let g:user_workspace_active = "default"
    endif

    if exists("g:user_workspace_active") && g:user_workspace_active != "default" && exists("l:valid_env") && l:valid_env
        let workspace_title = workspace_title . g:user_workspace_active
    else
        let workspace_title = workspace_title . g:const_currentdir
    endif

    let &titlestring = workspace_title

    " load makefile into makeprg
    if exists("l:valid_env") && l:valid_env
        let &makeprg = "make -f " . l:makefile_name
    elseif exists("l:valid_env") && !l:valid_env
        echom "ERROR: environment invalid"
    endif
endfunction

" opens workspace makefile for editing in the current buffer. if no env is
" provided, then the current workspace makefile will be opened (if a workspace
" is loaded)
function EditWorkspace(...)
    if !a:0
        if exists("g:user_workspace_active") && g:user_workspace_active != "default"
            let makefile_name = g:const_workspace_env_dir . "/" . g:user_workspace_active . ".mk"
            execute "edit " . makefile_name
            return
        else
            echom "ERROR: no environment provided"
            return
        endif
    endif

    let makefile_name = g:const_workspace_env_dir . "/" . a:1 . ".mk"
    let valid_env = filereadable(makefile_name)

    if valid_env
        execute "edit " . makefile_name
    else
        echom "ERROR: invalid environment"
    endif
endfunction

function ExitWorkspace()
    if !exists("g:user_workspace_active")
        echom "ERROR: no workspace active"
        return
    endif

    unlet g:user_workspace_active
    let &titlestring = &titleold
    set notitle
    NERDTreeClose
endfunction

" :qa is awkward and i hate it
cmap qq qa

