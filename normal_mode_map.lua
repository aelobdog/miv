local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local miv = require "plugins.miv.miv"

local normal_mode_map = {
    ["h"] = function() command.perform("doc:move-to-previous-char") end,
    ["l"] = function() command.perform("doc:move-to-next-char") end,
    ["j"] = function() command.perform("doc:move-to-next-line") end,
    ["k"] = function() command.perform("doc:move-to-previous-line") end,
    ["left"] = function() command.perform("doc:move-to-previous-char") end,
    ["right"] = function() command.perform("doc:move-to-next-char") end,
    ["down"] = function() command.perform("doc:move-to-next-line") end,
    ["up"] = function() command.perform("doc:move-to-previous-line") end,
    ["0"] = function() command.perform("doc:move-to-start-of-line") end,
    ["$"] = function() command.perform("doc:move-to-end-of-line") end,
    ["b"] = function() command.perform("doc:move-to-previous-word-start") end,
    ["e"] = function() command.perform("doc:move-to-next-word-end") end,
    ["g g"] = function() command.perform("doc:move-to-start-of-doc") end,
    ["G"] = function() command.perform("doc:move-to-end-of-doc") end,
    ["u"] = function() command.perform("doc:undo") end,
    ["C-r"] = function() command.perform("doc:redo") end,
    ["{"] = function() command.perform("doc:move-to-previous-block-start") end,
    ["}"] = function() command.perform("doc:move-to-next-block-end") end,
    ["d d"] = function()
        local doc = core.active_view.doc
        local line = doc:get_selection(true)
        doc:remove(line, 0, line + 1, 0)
    end,
    ["x"] = function()
        local doc = core.active_view.doc
        local line, col = doc:get_selection(true)
        doc:remove(line, col, line, col + 1)
    end,
    ["i"] = function() miv.set_mode("insert") end,
    ["V"] = function()
        miv.set_mode("visual-lines")
        local line = core.active_view.doc:get_selection(true)
        miv.visual_line_start = line
        miv.visual_line_end = line + 1
        miv.update_visual_line_selection()
    end,
    ["v"] = function()
        miv.set_mode("visual")
        local line, col = core.active_view.doc:get_selection(true)
        miv.visual_line_start = line
        miv.visual_line_end = line
        miv.visual_col_start = col
        miv.visual_col_end = col
        miv.update_visual_selection()
    end
}

return normal_mode_map