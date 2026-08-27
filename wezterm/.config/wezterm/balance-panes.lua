local wezterm = require("wezterm")
local action = wezterm.action

-- Equalize all panes: each column gets equal width, each row within a column gets
-- equal height. Weights are column/row group counts so mixed split orientations
-- produce the expected N-ary equal-split layout.
--
-- WezTerm's AdjustPaneSize targets the nearest ancestor split in the internal tree,
-- which may differ from our reconstructed tree (multiple binary trees produce the same
-- pixel layout). We probe with +1 adjustments to discover which boundary each pane
-- actually targets, verifying by checking that panes on BOTH sides of the intended
-- boundary are affected. This ensures adjustments hit the correct split bar.
local function equalize_tab(window)
    local tab = window:active_tab()
    local initial_panes = tab:panes_with_info()
    if #initial_panes <= 1 then
        return
    end

    local active_idx = 0
    for _, pi in ipairs(initial_panes) do
        if pi.is_active then
            active_idx = pi.index
        end
    end

    -- Reconstruct the binary split tree from pane positions.
    local function build_tree(ps)
        if #ps == 1 then
            return { type = "pane", pane = ps[1], width = ps[1].width, height = ps[1].height }
        end

        local xs = {}
        for _, p in ipairs(ps) do
            xs[p.left + p.width] = true
        end
        local xs_sorted = {}
        for x in pairs(xs) do
            table.insert(xs_sorted, x)
        end
        table.sort(xs_sorted)
        for _, x in ipairs(xs_sorted) do
            local left_ps, right_ps = {}, {}
            for _, p in ipairs(ps) do
                if p.left + p.width <= x then
                    table.insert(left_ps, p)
                elseif p.left >= x then
                    table.insert(right_ps, p)
                end
            end
            if #left_ps + #right_ps == #ps and #left_ps > 0 and #right_ps > 0 then
                local lc = build_tree(left_ps)
                local rc = build_tree(right_ps)
                return {
                    type = "vsplit",
                    left_child = lc,
                    right_child = rc,
                    width = lc.width + rc.width,
                    height = lc.height,
                }
            end
        end

        local ys = {}
        for _, p in ipairs(ps) do
            ys[p.top + p.height] = true
        end
        local ys_sorted = {}
        for y in pairs(ys) do
            table.insert(ys_sorted, y)
        end
        table.sort(ys_sorted)
        for _, y in ipairs(ys_sorted) do
            local top_ps, bot_ps = {}, {}
            for _, p in ipairs(ps) do
                if p.top + p.height <= y then
                    table.insert(top_ps, p)
                elseif p.top >= y then
                    table.insert(bot_ps, p)
                end
            end
            if #top_ps + #bot_ps == #ps and #top_ps > 0 and #bot_ps > 0 then
                local tc = build_tree(top_ps)
                local bc = build_tree(bot_ps)
                return {
                    type = "hsplit",
                    top_child = tc,
                    bot_child = bc,
                    width = tc.width,
                    height = tc.height + bc.height,
                }
            end
        end

        return { type = "pane", pane = ps[1], width = ps[1].width, height = ps[1].height }
    end

    -- Leftmost/topmost pane in subtree (first-child path — cascade preserver).
    local function near_pane(node)
        if node.type == "pane" then
            return node.pane
        end
        if node.type == "vsplit" then
            return near_pane(node.left_child)
        end
        return near_pane(node.top_child)
    end

    -- Rightmost/bottommost pane in subtree (second-child path — cascade absorber).
    local function far_pane(node)
        if node.type == "pane" then
            return node.pane
        end
        if node.type == "vsplit" then
            return far_pane(node.right_child)
        end
        return far_pane(node.bot_child)
    end

    -- Collect all leaf panes in a subtree.
    local function collect_panes(node, out)
        out = out or {}
        if node.type == "pane" then
            table.insert(out, node.pane)
        elseif node.type == "vsplit" then
            collect_panes(node.left_child, out)
            collect_panes(node.right_child, out)
        elseif node.type == "hsplit" then
            collect_panes(node.top_child, out)
            collect_panes(node.bot_child, out)
        end
        return out
    end

    local function count_columns(node)
        if node.type == "vsplit" then
            return count_columns(node.left_child) + count_columns(node.right_child)
        end
        return 1
    end

    local function count_rows(node)
        if node.type == "hsplit" then
            return count_rows(node.top_child) + count_rows(node.bot_child)
        end
        return 1
    end

    -- Snapshot pane sizes keyed by index.
    local function snapshot()
        local s = {}
        for _, pi in ipairs(tab:panes_with_info()) do
            s[pi.index] = { width = pi.width, height = pi.height }
        end
        return s
    end

    -- Probe from a candidate pane to see if it targets the intended boundary.
    -- Returns "grow"/"shrink"/nil indicating the effect of pos_dir on the
    -- first-child side of the intended boundary.
    -- pos_dir/neg_dir: e.g. "Right"/"Left" for vsplits, "Down"/"Up" for hsplits.
    -- prop: "width" or "height".
    -- verify_pane: a pane on the OTHER side whose size must also change.
    local function probe(candidate_idx, pos_dir, neg_dir, prop, verify_idx)
        local before = snapshot()
        window:perform_action(action.ActivatePaneByIndex(candidate_idx), tab:active_pane())
        window:perform_action(action.AdjustPaneSize({ pos_dir, 1 }), tab:active_pane())
        local after = snapshot()

        local cand_delta = after[candidate_idx][prop] - before[candidate_idx][prop]
        local verify_delta = after[verify_idx][prop] - before[verify_idx][prop]

        -- Undo the probe
        window:perform_action(action.AdjustPaneSize({ neg_dir, 1 }), tab:active_pane())

        if cand_delta ~= 0 and verify_delta ~= 0 and cand_delta ~= verify_delta then
            return cand_delta > 0 and "grow" or "shrink"
        end
        return nil
    end

    -- Try to adjust a boundary using probe-and-discover.
    -- candidate_panes: list of {index, side} to try ("left" or "right" of boundary).
    -- delta: desired change to first-child size (positive = grow first child).
    -- pos_dir/neg_dir: direction pair (e.g. "Right"/"Left").
    -- prop: "width" or "height".
    -- verify_idx: pane on opposite side to verify correct boundary.
    local function try_adjust(candidates, delta, pos_dir, neg_dir, prop)
        for _, c in ipairs(candidates) do
            local result = probe(c.index, pos_dir, neg_dir, prop, c.verify)
            if result then
                window:perform_action(action.ActivatePaneByIndex(c.index), tab:active_pane())
                -- result tells us what pos_dir does to this pane relative to the boundary.
                -- We need to figure out what direction achieves our desired delta.
                if c.side == "left" then
                    -- Candidate is on left/top side. We want delta applied to left side.
                    if result == "grow" then
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ pos_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ neg_dir, -delta }), tab:active_pane())
                        end
                    else
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ neg_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ pos_dir, -delta }), tab:active_pane())
                        end
                    end
                else
                    -- Candidate is on right/bot side. pos_dir effect on candidate is
                    -- opposite to its effect on the first-child side.
                    if result == "grow" then
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ neg_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ pos_dir, -delta }), tab:active_pane())
                        end
                    else
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ pos_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ neg_dir, -delta }), tab:active_pane())
                        end
                    end
                end
                return true
            end
        end
        return false
    end

    -- BFS: process one boundary at a time, re-reading between each.
    for _ = 1, #initial_panes - 1 do
        local ps = tab:panes_with_info()
        local tree = build_tree(ps)

        -- Find shallowest unbalanced split (BFS).
        local queue = { tree }
        local adjusted = false
        while #queue > 0 and not adjusted do
            local node = table.remove(queue, 1)
            if node.type == "vsplit" then
                local lc, rc = node.left_child, node.right_child
                local l_cols = count_columns(lc)
                local r_cols = count_columns(rc)
                local total = lc.width + rc.width
                local target_l = math.floor(total * l_cols / (l_cols + r_cols))
                local delta = target_l - lc.width
                if delta ~= 0 then
                    local left_panes = collect_panes(lc)
                    local right_panes = collect_panes(rc)
                    local right_far = far_pane(rc)
                    local left_far = far_pane(lc)
                    local candidates = {}
                    for _, p in ipairs(left_panes) do
                        table.insert(candidates, { index = p.index, side = "left", verify = right_far.index })
                    end
                    for _, p in ipairs(right_panes) do
                        table.insert(candidates, { index = p.index, side = "right", verify = left_far.index })
                    end
                    adjusted = try_adjust(candidates, delta, "Right", "Left", "width")
                end
                if not adjusted then
                    table.insert(queue, lc)
                    table.insert(queue, rc)
                end
            elseif node.type == "hsplit" then
                local tc, bc = node.top_child, node.bot_child
                local t_rows = count_rows(tc)
                local b_rows = count_rows(bc)
                local total = tc.height + bc.height
                local target_t = math.floor(total * t_rows / (t_rows + b_rows))
                local delta = target_t - tc.height
                if delta ~= 0 then
                    local top_panes = collect_panes(tc)
                    local bot_panes = collect_panes(bc)
                    local bot_far = far_pane(bc)
                    local top_far = far_pane(tc)
                    local candidates = {}
                    for _, p in ipairs(top_panes) do
                        table.insert(candidates, { index = p.index, side = "left", verify = bot_far.index })
                    end
                    for _, p in ipairs(bot_panes) do
                        table.insert(candidates, { index = p.index, side = "right", verify = top_far.index })
                    end
                    adjusted = try_adjust(candidates, delta, "Down", "Up", "height")
                end
                if not adjusted then
                    table.insert(queue, tc)
                    table.insert(queue, bc)
                end
            end
        end
        if not adjusted then
            break
        end
    end

    window:perform_action(action.ActivatePaneByIndex(active_idx), tab:active_pane())
end

-- Split and equalize all panes in the current tab
local function split_and_equalize(direction)
    return wezterm.action_callback(function(window, pane)
        if direction == "vertical" then
            window:perform_action(action.SplitPane({ direction = "Down" }), pane)
        else
            window:perform_action(action.SplitPane({ direction = "Right" }), pane)
        end
        equalize_tab(window)
    end)
end

-- Example keybindings (using Ctrl+Space as leader):
--
-- config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
-- config.keys = {
--     { key = "s", mods = "LEADER", action = split_and_equalize("vertical") },
--     { key = "v", mods = "LEADER", action = split_and_equalize("horizontal") },
--     { key = "=", mods = "LEADER", action = wezterm.action_callback(function(window) equalize_tab(window) end) },
--     {
--         key = "q",
--         mods = "LEADER",
--         action = wezterm.action_callback(function(window, pane)
--             window:perform_action(action.CloseCurrentPane({ confirm = false }), pane)
--             equalize_tab(window)
--         end),
--     },
-- }

return { equalize_tab = equalize_tab, split_and_equalize = split_and_equalize }
