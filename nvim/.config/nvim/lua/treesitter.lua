local ts_config = require("treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "bash",
        "go",
        "json",
        "lua",
        "python",
        "terraform",
        "yaml",
    },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}
