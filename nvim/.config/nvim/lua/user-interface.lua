require "bufferline".setup {
    options = {
        enforce_regular_tabs = false,
        mappings = "true"
        max_name_length = 14,
        max_prefix_length = 13,
        offsets = {{filetype = "NvimTree", text = ""}},
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_tab_indicators = true,
        tab_size = 20,
        view = "multiwindow",
    }
}

local opt = {silent = true}
local map = vim.api.nvim_set_keymap

-- MAPPINGS
map("n", "<S-t>", [[<Cmd>tabnew<CR>]], opt)  -- new tab
map("n", "<S-x>", [[<Cmd>bdelete<CR>]], opt) -- close tab

-- move between tabs
map("n", "<TAB>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
map("n", "<S-TAB>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)
