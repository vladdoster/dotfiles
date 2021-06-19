local ts_config = require('nvim-treesitter.configs')

ts_config.setup {
    ensure_installed = {'bash', 'lua', 'json', 'python'},
    highlight = {enable = true, use_languagetree = true}
}
