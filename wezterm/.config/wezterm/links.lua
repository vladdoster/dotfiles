local wezterm = require('wezterm')

local M = {}

function M.setup(config)
  config.hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    --
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },
    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },
    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },
    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },
    -- Local paths: /abs, ~/x, ./x, ../x with optional :line:col suffix.
    -- The open-uri handler below resolves and opens them.
    {
      regex = [[(?:^|[\s"'(=])((?:~|\.{1,2})?/[\w.+@%-]+(?:/[\w.+@%-]+)*)(?::\d+){0,2}]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Names in long listings. The name is the last column, relative to the pane cwd.
    -- eza/exa: "5 Nov 00:16 name" or "5 Nov  2024 name". Drop a symlink " -> target".
    {
      regex = [[\d{1,2} [A-Z][a-z]{2}\s+(?:\d{2}:\d{2}|\d{4}) (.+?)(?: -> .*)?$]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- BSD/GNU ls -l: "Nov  5 00:16 name" or "Nov  5  2024 name".
    {
      regex = [[[A-Z][a-z]{2}\s+\d{1,2}\s+(?:\d{2}:\d{2}|\d{4}) (.+?)(?: -> .*)?$]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Symlink target in a long listing. Without this the GitHub rule below links its pieces.
    {
      regex = [[(?:\d{2}:\d{2}|\d{4}) .+? -> (.+)$]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = 'https://www.github.com/$1/$3',
    },
  }

  wezterm.on('open-uri', function(window, pane, uri)
    local path = uri:match('^localpath:(.+)$')
    if not path then
      return nil
    end
    if path:sub(1, 2) == '~/' then
      path = wezterm.home_dir .. path:sub(2)
    elseif path:sub(1, 1) ~= '/' then
      local cwd = pane:get_current_working_dir()
      if not cwd then
        window:toast_notification('wezterm', 'Unknown pane cwd: ' .. path, nil, 4000)
        return false
      end
      path = cwd.file_path:gsub('/+$', '') .. '/' .. path
    end
    local ok, _, stderr = wezterm.run_child_process({ 'open', path })
    if not ok then
      window:toast_notification('wezterm', 'Cannot open ' .. path .. ': ' .. stderr, nil, 4000)
    end
    return false
  end)
end

return M
