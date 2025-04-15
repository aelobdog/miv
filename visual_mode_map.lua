local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local miv = require "plugins.miv.miv"

local visual_mode_map = {
    ["escape"] = function()
        miv.set_mode("normal")
        miv.visual_line_start = miv.visual_line_end
        miv.visual_col_start = miv.visual_col_end 
        miv.update_visual_selection()
        miv.visual_line_start = nil
        miv.visual_line_end = nil
        miv.visual_col_start = nil
        miv.visual_col_end = nil
    end,
    ["j"] = function()
        miv.visual_line_end = miv.visual_line_end + 1
        miv.visual_col_end = miv.visual_col_start
        miv.update_visual_selection()
    end,
    ["k"] = function()
        miv.visual_line_end = miv.visual_line_end - 1
        miv.visual_col_end = miv.visual_col_start
        miv.update_visual_selection()
    end,
    ["h"] = function()
        miv.visual_col_end = miv.visual_col_end - 1
        miv.update_visual_selection()
    end,
    ["l"] = function()
        miv.visual_col_end = miv.visual_col_end + 1
        miv.update_visual_selection()
    end,
    ["d"] = function()
        miv.set_mode("normal")
        local doc = core.active_view.doc
        doc:remove(miv.visual_line_start, miv.visual_col_start, miv.visual_line_end, miv.visual_col_end)
        miv.visual_line_end = miv.visual_line_start
        miv.visual_col_end = miv.visual_col_start
        miv.update_visual_selection()
        miv.visual_line_start = nil
        miv.visual_line_end = nil
        miv.visual_col_start = nil
        miv.visual_col_end = nil
    end,
    ["g g"] = function()
        miv.visual_line_end = 1
        miv.update_visual_selection()
    end,
    ["G"] = function()
        local doc = core.active_view.doc
        miv.visual_line_end = #doc.lines
        miv.update_visual_selection()
    end,
}

return visual_mode_map