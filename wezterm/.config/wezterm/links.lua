local wezterm = require('wezterm')

local M = {}

function M.setup(config)
  -- The default wezterm rules match URLs of any scheme and host, and email addresses.
  local rules = wezterm.default_hyperlink_rules()
  -- Compact JSON puts text straight after the closing quote of a URL.
  -- Stop each URL match at a double quote.
  for _, rule in ipairs(rules) do
    rule.regex = rule.regex:gsub('%[%^\\s', '[^\\s"'):gsub('\\S', '[^\\s"]')
  end
  for _, rule in ipairs({
    -- Local paths: /abs, ~/x, ./x, ../x with optional :line:col suffix.
    -- The open-uri handler below resolves and opens them.
    {
      regex = [[(?:^|[\s"'(=])((?:~|\.{1,2})?/[\w.+@%-]+(?:/[\w.+@%-]+)*)(?::\d+){0,2}]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Match bare relative paths of three or more segments, such as src/pkg/mod.py. The open-uri
    -- handler resolves them against the pane cwd. A final period belongs to the sentence.
    {
      regex = [[(?:^|[\s"'(=])([\w.+@%-]+(?:/[\w.+@%-]+){2,}(?<!\.))(?::\d+){0,2}]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Symlink target in a long listing. Without this the GitHub rule below links its pieces.
    {
      regex = [[(?:\d{2}:\d{2}|\d{4}) .+? -> (.*\S)]],
      format = 'localpath:$1',
      highlight = 1,
    },
    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    -- The lookarounds reject a piece of a longer path, such as src/pkg in a/src/pkg/b.
    {
      regex = [[(?<![\w./-])["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?(?![\w./-])]],
      format = 'https://www.github.com/$1/$3',
    },
  }) do
    table.insert(rules, rule)
  end
  config.hyperlink_rules = rules

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
