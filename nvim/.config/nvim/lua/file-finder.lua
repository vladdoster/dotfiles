local g = vim.g
-- global options
vim.o.termguicolors = true
-- nvim-tree
g.nvim_tree_allow_resize = 1
g.nvim_tree_auto_close = 0
g.nvim_tree_auto_open = 0
g.nvim_tree_follow = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
g.nvim_tree_indent_markers = 1
g.nvim_tree_quit_on_open = 1
g.nvim_tree_root_folder_modifier = ":t"
g.nvim_tree_side = "left"
g.nvim_tree_tab_open = 0
g.nvim_tree_width = 26
-- KEY BINDINGS
vim.api.nvim_set_keymap(
    "n",
    "<C-n>",
    ":NvimTreeToggle<CR>",
    {
        noremap = true,
        silent  = true
    }
)
-- VISUAL SYMBOLS
g.nvim_tree_show_icons = {
    files   = 1,
    folders = 1,
    git     = 1
}
-- INIT
local tree_cb = require "file-finder.config".nvim_tree_callback
