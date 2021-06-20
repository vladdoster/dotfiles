vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set inccommand=split') -- Make substitution work in realtime

vim.o.title = true
TERMINAL = vim.fn.expand('$TERMINAL')
vim.cmd('let &titleold="' .. TERMINAL
            .. '"')
vim.o.titlestring = '%<%F%=%l/%L - nvim'

-- vim.o.guifont = "JetBrains\\ Mono\\ Regular\\ Nerd\\ Font\\ Complete"
vim.bo.smartindent = true -- Makes indenting smart
vim.cmd('filetype plugin on') -- filetype detection
vim.cmd('set colorcolumn=99999') -- fix indentline for now
vim.cmd('set expandtab') -- Converts tabs to spaces
vim.cmd('set sw=4') -- Change the number of space characters inserted for indentation
vim.cmd('set ts=4') -- Insert 2 spaces for a tab
vim.cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
vim.cmd('syntax on') -- syntax highlighting
vim.g.loaded_netrwPlugin = 1 -- needed for netrw gx command to open remote links in browser
vim.o.backup = false -- This is recommended by coc
vim.o.clipboard = 'unnamedplus' -- Copy paste between vim and everything else
vim.o.cmdheight = 2 -- More space for displaying messages
vim.o.conceallevel = 0 -- So that I can see `` in markdown files
vim.o.fileencoding = 'utf-8' -- The encoding written to file
vim.o.guifont =
    'JetBrainsMono\\ Nerd\\ Font\\ Mono:h18'
vim.o.mouse = 'a' -- Enable your mouse
vim.o.pumheight = 10 -- Makes popup menu smaller
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore
vim.o.showtabline = 2 -- Always show tabs
vim.o.splitbelow = true -- Horizontal splits will automatically be below
vim.o.splitright = true -- Vertical splits will automatically be to the right
vim.o.termguicolors = true -- set term gui colors most terminals support this
vim.o.updatetime = 300 -- Faster completion
vim.o.writebackup = false -- This is recommended by coc
vim.wo.cursorline = true -- Enable highlighting of the current line
vim.wo.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
