local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- OPEN TERMINALS --
map('n', '<C-l>', [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
map('n', '<C-x>', [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
map('n', '<C-t>t', [[<Cmd> tabnew | term <CR>]], opt) -- term newtab

-- Tab switch buffer
vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>', {noremap = true, silent = true})

-- COPY EVERYTHING --
map('n', '<C-a>', [[ <Cmd> %y+<CR>]], opt)

-- toggle numbers ---
map('n', '<leader>n', [[ <Cmd> set nu!<CR>]], opt)
