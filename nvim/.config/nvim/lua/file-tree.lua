local g = vim.g

-- RANGER FM -------------------------------------
vim.api.nvim_set_keymap('n', '-',
                        ':RnvimrToggle<CR>',
                        {
    noremap = true,
    silent = true
})
-- settings
g.rnvimr_ex_enable = 1
g.rnvimr_draw_border = 1
g.rnvimr_pick_enable = 1
g.rnvimr_bw_enable = 1
-- NVIM TREE -------------------------------------
vim.api.nvim_set_keymap('n', '<C-n>',
                        ':NvimTreeToggle<CR>',
                        {
    noremap = true,
    silent = true
})
-- settings
g.nvim_tree_hijack_netrw = 1
g.nvim_tree_auto_close = 1
g.nvim_tree_disable_netrw = 1
g.nvim_tree_follow = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1
}
-- bindings

