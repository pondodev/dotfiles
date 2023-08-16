" custom binds for various functionality

" git
nmap <C-g>a :Git<Space>add<Space>%<CR>
nmap <C-g>c :Git<Space>commit<CR>
nmap <C-g>b :Git<Space>blame<CR>
nmap <C-g>l :Git<Space>log<CR>
nmap <C-g>d :Git<Space>diff<Space>%<CR>
nmap <C-g>s :Git<Space>status<CR>

" make
nmap mb<CR> :Make<Space>build<CR>
nmap mc<CR> :Make<Space>clean<CR>

" nerdtree
map <C-e> :NERDTreeToggle<CR>
map! <C-e> :NERDTreeToggle<CR>

" folds
noremap <Space> za
noremap <CR> zA

" telescope binds
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

