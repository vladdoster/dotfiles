-- RANGER FM -------------------------------------
vim.api.nvim_set_keymap('n', '-', ':RnvimrToggle<CR>', {noremap = true, silent = true})
-- settings
vim.g.rnvimr_ex_enable = 1
vim.g.rnvimr_draw_border = 1
vim.g.rnvimr_pick_enable = 1
vim.g.rnvimr_bw_enable = 1
-- NVIM TREE -------------------------------------
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
-- settings
vim.g.nvim_ree_hijack_netrw = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_disable_netrw = 1 
vim.g.nvim_tree_follow = 1 
vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1}
-- bindings
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
    -- default mappings
    ['-'] = tree_cb('dir_up'),
    ['<'] = tree_cb('prev_sibling'),
    ['<2-LeftMouse>'] = tree_cb('edit'),
    ['<2-RightMouse>'] = tree_cb('cd'),
    ['<BS>'] = tree_cb('close_node'),
    ['<C-]>'] = tree_cb('cd'),
    ['<C-r>'] = tree_cb('full_rename'),
    ['<C-t>'] = tree_cb('tabnew'),
    ['<CR>'] = tree_cb('edit'),
    ['<S-CR>'] = tree_cb('close_node'),
    ['<Tab>'] = tree_cb('preview'),
    ['>'] = tree_cb('next_sibling'),
    ['H'] = tree_cb('toggle_dotfiles'),
    ['I'] = tree_cb('toggle_ignored'),
    ['R'] = tree_cb('refresh'),
    ['[c'] = tree_cb('prev_git_item'),
    [']c'] = tree_cb('next_git_item'),
    ['a'] = tree_cb('create'),
    ['c'] = tree_cb('copy'),
    ['d'] = tree_cb('remove'),
    ['h'] = tree_cb('close_node'),
    ['l'] = tree_cb('edit'),
    ['o'] = tree_cb('edit'),
    ['p'] = tree_cb('paste'),
    ['q'] = tree_cb('close'),
    ['r'] = tree_cb('rename'),
    ['s'] = tree_cb('split'),
    ['v'] = tree_cb('vsplit'),
    ['x'] = tree_cb('cut'),
}


