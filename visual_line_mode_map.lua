local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local miv = require "plugins.miv.miv"

local visual_line_mode_map = {
    ["escape"] = function()
        miv.set_mode("normal")
        miv.visual_line_start = miv.visual_line_end 
        miv.update_visual_line_selection()
        miv.visual_line_start = nil
        miv.visual_line_end = nil
    end,
    ["j"] = function()
        miv.visual_line_end = miv.visual_line_end + 1
        miv.update_visual_line_selection()
    end,
    ["k"] = function()
        -- TODO: there's a known issue where if we're selecting some lines
        --       and we move the cursor up, we end up with a "no-selection"
        --       when we come up the the first line that was selected ...
        miv.visual_line_end = miv.visual_line_end - 1
        miv.update_visual_line_selection()
    end,
    ["d"] = function()
        miv.set_mode("normal")
        local doc = core.active_view.doc
        doc:remove(miv.visual_line_start, 0, miv.visual_line_end, 0)
        miv.visual_line_end = miv.visual_line_start
        miv.update_visual_line_selection()
        miv.visual_line_start = nil
        miv.visual_line_end = nil
    end,
    ["g g"] = function()
        miv.visual_line_end = 1
        miv.update_visual_line_selection()
    end,
    ["G"] = function()
        local doc = core.active_view.doc
        miv.visual_line_end = #doc.lines
        miv.update_visual_line_selection()
    end,
}

return visual_line_mode_map