-- mod-version:3

local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local translate = require "core.doc.translate"

-- ----------------------------------------------------------------------------

local miv = {}

miv.mode = "normal"
miv.key_buffer = {}
miv.key_timeout = 0.3

function miv.set_mode(mode)
  miv.mode = mode
  miv.key_buffer = {}
end

local visual_line_start = nil
local visual_line_end = nil

local visual_col_start = nil
local visual_col_end = nil

-- ----------------------------------------------------------------------------

local function update_visual_line_selection()
  local doc = core.active_view.doc
  local start_line = visual_line_start
  local end_line = visual_line_end
  doc:set_selection(end_line, 0, start_line, 0)
end

local function update_visual_selection()
  local doc = core.active_view.doc
  local start_line = visual_line_start
  local end_line = visual_line_end
  local start_col = visual_col_start
  local end_col = visual_col_end
  doc:set_selection(end_line, end_col, start_line, start_col)
end

-- ----------------------------------------------------------------------------

miv.normal_mode_map = {
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
  ["i"] = function() miv.set_mode("insert") end,
  ["V"] = function()
    miv.set_mode("visual-lines")
    local line = core.active_view.doc:get_selection(true)
    visual_line_start = line
    visual_line_end = line + 1
    update_visual_line_selection()
  end,
  ["v"] = function()
    miv.set_mode("visual")
    local line, col = core.active_view.doc:get_selection(true)
    visual_line_start = line
    visual_line_end = line
    visual_col_start = col
    visual_col_end = col
    update_visual_selection()
  end
}

miv.insert_mode_map = {
  ["escape"] = function() miv.set_mode("normal") end,
  ["space"] = function() core.active_view.doc:text_input(" ") end,
  ["!"] = function() core.active_view.doc:text_input("!") end,
  ["\""] = function() core.active_view.doc:text_input("\"") end,
  ["#"] = function() core.active_view.doc:text_input("#") end,
  ["$"] = function() core.active_view.doc:text_input("$") end,
  ["%"] = function() core.active_view.doc:text_input("%") end,
  ["&"] = function() core.active_view.doc:text_input("&") end,
  ["'"] = function() core.active_view.doc:text_input("'") end,
  ["("] = function() core.active_view.doc:text_input("(") end,
  [")"] = function() core.active_view.doc:text_input(")") end,
  ["*"] = function() core.active_view.doc:text_input("*") end,
  ["+"] = function() core.active_view.doc:text_input("+") end,
  [","] = function() core.active_view.doc:text_input(",") end,
  ["-"] = function() core.active_view.doc:text_input("-") end,
  ["."] = function() core.active_view.doc:text_input(".") end,
  ["/"] = function() core.active_view.doc:text_input("/") end,
  ["0"] = function() core.active_view.doc:text_input("0") end,
  ["1"] = function() core.active_view.doc:text_input("1") end,
  ["2"] = function() core.active_view.doc:text_input("2") end,
  ["3"] = function() core.active_view.doc:text_input("3") end,
  ["4"] = function() core.active_view.doc:text_input("4") end,
  ["5"] = function() core.active_view.doc:text_input("5") end,
  ["6"] = function() core.active_view.doc:text_input("6") end,
  ["7"] = function() core.active_view.doc:text_input("7") end,
  ["8"] = function() core.active_view.doc:text_input("8") end,
  ["9"] = function() core.active_view.doc:text_input("9") end,
  ["a"] = function() core.active_view.doc:text_input("a") end,
  ["b"] = function() core.active_view.doc:text_input("b") end,
  ["c"] = function() core.active_view.doc:text_input("c") end,
  ["d"] = function() core.active_view.doc:text_input("d") end,
  ["e"] = function() core.active_view.doc:text_input("e") end,
  ["f"] = function() core.active_view.doc:text_input("f") end,
  ["g"] = function() core.active_view.doc:text_input("g") end,
  ["h"] = function() core.active_view.doc:text_input("h") end,
  ["i"] = function() core.active_view.doc:text_input("i") end,
  ["j"] = function() core.active_view.doc:text_input("j") end,
  ["k"] = function() core.active_view.doc:text_input("k") end,
  ["l"] = function() core.active_view.doc:text_input("l") end,
  ["m"] = function() core.active_view.doc:text_input("m") end,
  ["n"] = function() core.active_view.doc:text_input("n") end,
  ["o"] = function() core.active_view.doc:text_input("o") end,
  ["p"] = function() core.active_view.doc:text_input("p") end,
  ["q"] = function() core.active_view.doc:text_input("q") end,
  ["r"] = function() core.active_view.doc:text_input("r") end,
  ["s"] = function() core.active_view.doc:text_input("s") end,
  ["t"] = function() core.active_view.doc:text_input("t") end,
  ["u"] = function() core.active_view.doc:text_input("u") end,
  ["v"] = function() core.active_view.doc:text_input("v") end,
  ["w"] = function() core.active_view.doc:text_input("w") end,
  ["x"] = function() core.active_view.doc:text_input("x") end,
  ["y"] = function() core.active_view.doc:text_input("y") end,
  ["z"] = function() core.active_view.doc:text_input("z") end,
  ["A"] = function() core.active_view.doc:text_input("A") end,
  ["B"] = function() core.active_view.doc:text_input("B") end,
  ["C"] = function() core.active_view.doc:text_input("C") end,
  ["D"] = function() core.active_view.doc:text_input("D") end,
  ["E"] = function() core.active_view.doc:text_input("E") end,
  ["F"] = function() core.active_view.doc:text_input("F") end,
  ["G"] = function() core.active_view.doc:text_input("G") end,
  ["H"] = function() core.active_view.doc:text_input("H") end,
  ["I"] = function() core.active_view.doc:text_input("I") end,
  ["J"] = function() core.active_view.doc:text_input("J") end,
  ["K"] = function() core.active_view.doc:text_input("K") end,
  ["L"] = function() core.active_view.doc:text_input("L") end,
  ["M"] = function() core.active_view.doc:text_input("M") end,
  ["N"] = function() core.active_view.doc:text_input("N") end,
  ["O"] = function() core.active_view.doc:text_input("O") end,
  ["P"] = function() core.active_view.doc:text_input("P") end,
  ["Q"] = function() core.active_view.doc:text_input("Q") end,
  ["R"] = function() core.active_view.doc:text_input("R") end,
  ["S"] = function() core.active_view.doc:text_input("S") end,
  ["T"] = function() core.active_view.doc:text_input("T") end,
  ["U"] = function() core.active_view.doc:text_input("U") end,
  ["V"] = function() core.active_view.doc:text_input("V") end,
  ["W"] = function() core.active_view.doc:text_input("W") end,
  ["X"] = function() core.active_view.doc:text_input("X") end,
  ["Y"] = function() core.active_view.doc:text_input("Y") end,
  ["Z"] = function() core.active_view.doc:text_input("Z") end,
  [":"] = function() core.active_view.doc:text_input(":") end,
  [";"] = function() core.active_view.doc:text_input(";") end,
  ["<"] = function() core.active_view.doc:text_input("<") end,
  [">"] = function() core.active_view.doc:text_input(">") end,
  ["?"] = function() core.active_view.doc:text_input("?") end,
  ["@"] = function() core.active_view.doc:text_input("@") end,
  ["["] = function() core.active_view.doc:text_input("[") end,
  ["]"] = function() core.active_view.doc:text_input("]") end,
  ["^"] = function() core.active_view.doc:text_input("^") end,
  ["_"] = function() core.active_view.doc:text_input("_") end,
  ["`"] = function() core.active_view.doc:text_input("`") end,
  ["{"] = function() core.active_view.doc:text_input("{") end,
  ["}"] = function() core.active_view.doc:text_input("}") end,
  ["|"] = function() core.active_view.doc:text_input("|") end,
  ["\\"] = function() core.active_view.doc:text_input("\\") end,
  ["return"] = function() core.active_view.doc:text_input("\n") end,
  ["tab"] = function() core.active_view.doc:text_input("\t") end,
  ["backspace"] = function() command.perform("doc:backspace") end,
  ["delete"] = function() command.perform("doc:delete") end,
  ["left"] = function() command.perform("doc:move-to-previous-char") end,
  ["right"] = function() command.perform("doc:move-to-next-char") end,
  ["down"] = function() command.perform("doc:move-to-next-line") end,
  ["up"] = function() command.perform("doc:move-to-previous-line") end,
}

miv.visual_line_mode_map = {
  ["escape"] = function()
    miv.set_mode("normal")
    visual_line_start = visual_line_end 
    update_visual_line_selection()
    visual_line_start = nil
    visual_line_end = nil
  end,
  ["j"] = function()
    visual_line_end = visual_line_end + 1
    update_visual_line_selection()
  end,
  ["k"] = function()
    -- TODO: there's a known issue where if we're selecting some lines
    --       and we move the cursor up, we end up with a "no-selection"
    --       when we come up the the first line that was selected ...
    visual_line_end = visual_line_end - 1
    update_visual_line_selection()
  end,
  ["d"] = function()
    miv.set_mode("normal")
    local doc = core.active_view.doc
    doc:remove(visual_line_start, 0, visual_line_end, 0)
    visual_line_end = visual_line_start
    update_visual_line_selection()
    visual_line_start = nil
    visual_line_end = nil
  end,
  ["g g"] = function()
    visual_line_end = 1
    update_visual_line_selection()
  end,
  ["G"] = function()
    local doc = core.active_view.doc
    visual_line_end = #doc.lines
    update_visual_line_selection()
  end,
}

miv.visual_mode_map = {
  ["escape"] = function()
    miv.set_mode("normal")
    visual_line_start = visual_line_end
    visual_col_start = visual_col_end 
    update_visual_selection()
    visual_line_start = nil
    visual_line_end = nil
    visual_col_start = nil
    visual_col_end = nil
  end,
  ["j"] = function()
    visual_line_end = visual_line_end + 1
    visual_col_end = visual_col_start
    update_visual_selection()
  end,
  ["k"] = function()
    visual_line_end = visual_line_end - 1
    visual_col_end = visual_col_start
    update_visual_selection()
  end,
  ["h"] = function()
    visual_col_end = visual_col_end - 1
    update_visual_selection()
  end,
  ["l"] = function()
    visual_col_end = visual_col_end + 1
    update_visual_selection()
  end,
  ["d"] = function()
    miv.set_mode("normal")
    local doc = core.active_view.doc
    doc:remove(visual_line_start, visual_col_start, visual_line_end, visual_col_end)
    visual_line_end = visual_line_start
    visual_col_end = visual_col_start
    update_visual_selection()
    visual_line_start = nil
    visual_line_end = nil
    visual_col_start = nil
    visual_col_end = nil
  end,
  ["g g"] = function()
    visual_line_end = 1
    update_visual_selection()
  end,
  ["G"] = function()
    local doc = core.active_view.doc
    visual_line_end = #doc.lines
    update_visual_selection()
  end,
}
-- ----------------------------------------------------------------------------

local old_on_key_pressed = keymap.on_key_pressed

-- ----------------------------------------------------------------------------
local macos = PLATFORM == "Mac OS X"
local modkeys_os = require("core.modkeys-" .. (macos and "macos" or "generic"))
local modkeys = modkeys_os.keys
local modmap = modkeys_os.map

-- ----------------------------------------------------------------------------

local function start_input_timeout()
  if miv.pending_timeout_thread then
    core.remove_thread(miv.pending_timeout_thread)
  end

  miv.pending_timeout_thread = core.add_thread(function()
    local start = os.clock()
    while os.clock() - start < miv.key_timeout do
      coroutine.yield(0.01)
    end

    -- timeout
    miv.key_buffer = {}
    miv.pending_timeout_thread = nil
  end)
end


local function shifted(key)
  if key:match("%l") then
      return key:upper()
  end

  local shift_map = {
      ["1"] = "!",  ["2"] = "@", ["3"] = "#",  ["4"] = "$",
      ["5"] = "%",  ["6"] = "^", ["7"] = "&",  ["8"] = "*",
      ["9"] = "(",  ["0"] = ")", ["-"] = "_",  ["="] = "+",
      ["["] = "{",  ["]"] = "}", ["\\"] = "|", [";"] = ":",
      ["'"] = "\"", [","] = "<", ["."] = ">",  ["/"] = "?",
      ["`"] = "~"
  }

  return shift_map[key] or key
end

local function shifted_stroke(combo)
  local parts = {}
  for part in combo:gmatch("[^-]+") do
    table.insert(parts, part)
  end

  local key = parts[#parts]
  local modifiers = {}

  for i = 1, #parts - 1 do
    if parts[i] ~= "S" then
      table.insert(modifiers, parts[i])
    end
  end

  if combo:find("S%-") then
    key = shifted(key)
  end

  table.insert(modifiers, key)
  return table.concat(modifiers, "-")
end

local function handle_keystroke(stroke)
  local current_mode_map = nil

  if miv.mode == "normal" then
    current_mode_map = miv.normal_mode_map
  elseif miv.mode == "insert" then
    current_mode_map = miv.insert_mode_map
  elseif miv.mode == "visual-lines" then
    current_mode_map = miv.visual_line_mode_map
  elseif miv.mode == "visual" then
    current_mode_map = miv.visual_mode_map
  end

  table.insert(miv.key_buffer, stroke)
  local joined = table.concat(miv.key_buffer, " ")

  -- Check for exact match
  if current_mode_map[joined] then
    current_mode_map[joined]()
    miv.key_buffer = {}
    miv.pending_timeout_thread = nil
    return true
  end

  if current_mode_map[shifted_stroke(joined)] then
    current_mode_map[shifted_stroke(joined)]()
    miv.key_buffer = {}
    miv.pending_timeout_thread = nil
    return true
  end

  -- Check for partial match
  local found_partial = false
  for seq, _ in pairs(current_mode_map) do
    if seq:sub(1, #joined) == joined then
      found_partial = true
      break
    end
  end

  if found_partial then
    start_input_timeout()
    return true
  else
    miv.key_buffer = {}
    miv.pending_timeout_thread = nil
    return false
  end
end

local function make_stroke(key)
  local stroke = key
  local C = false
  local M = false
  local S = false
  
  for _, mk in ipairs(modkeys) do
    if keymap.modkeys[mk] then
      if mk == "shift" then
        S = true
      end
      if mk == "alt" then
        M = true
      end
      if mk == "ctrl" then
        C = true
      end
    end
  end

  if S then stroke = "S-" .. stroke end
  if M then stroke = "M-" .. stroke end
  if C then stroke = "C-" .. stroke end

  return stroke
end

function keymap.on_key_pressed(k, ...)
  local mk = modmap[k]
  if mk then
    keymap.modkeys[mk] = true
    if mk == "altgr" then
      keymap.modkeys["ctrl"] = false
    end
  end
  local stroke = make_stroke(k)
  
  if stroke:find("wheel") or stroke:find("click") then
    return old_on_key_pressed(k, ...)
  else
    handle_keystroke(stroke)
    return true
  end

  return true
end

-- ----------------------------------------------------------------------------
