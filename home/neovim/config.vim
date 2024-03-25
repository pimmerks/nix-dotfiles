lua << EOF
-- Setup leader key
vim.g.mapleader = " "
EOF

" Setup clipboard
if has("unnamedplus")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif
