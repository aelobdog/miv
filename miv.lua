local core = require "core"

local miv = {}

miv.mode = "normal"
miv.key_buffer = {}
miv.key_timeout = 0.3
miv.visual_line_start = nil
miv.visual_line_end = nil
miv.visual_col_start = nil
miv.visual_col_end = nil

function miv.set_mode(mode)
    miv.mode = mode
    miv.key_buffer = {}
end

function miv.update_visual_line_selection()
    local doc = core.active_view.doc
    local start_line = miv.visual_line_start
    local end_line = miv.visual_line_end
    doc:set_selection(end_line, 0, start_line, 0)
end

function miv.update_visual_selection()
    local doc = core.active_view.doc
    local start_line = miv.visual_line_start
    local end_line = miv.visual_line_end
    local start_col = miv.visual_col_start
    local end_col = miv.visual_col_end
    doc:set_selection(end_line, end_col, start_line, start_col)
end

return miv