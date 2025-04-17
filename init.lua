-- mod-version:3

local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local CommandView = require "core.commandview"

-- ----------------------------------------------------------------------------
local miv = require "plugins.miv.miv"

miv.normal_mode_map = require "plugins.miv.normal_mode_map"
miv.insert_mode_map = require "plugins.miv.insert_mode_map"
miv.visual_mode_map = require "plugins.miv.visual_mode_map"
miv.visual_line_mode_map = require "plugins.miv.visual_line_mode_map"

-- ----------------------------------------------------------------------------
local old_on_key_pressed = keymap.on_key_pressed
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
  if #key == 1 and key:match("%l") then
      return key:upper()
  end

  local shift_map = {
      ["1"] = "!",  ["2"] = "@", ["3"] = "#",  ["4"] = "$",
      ["5"] = "%",  ["6"] = "^", ["7"] = "&",  ["8"] = "*",
      ["9"] = "(",  ["0"] = ")", ["minus"] = "_",  ["="] = "+",
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

  if stroke == "-" then stroke = "minus" end

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

  if stroke:find("wheel") or stroke:find("click") or core.active_view:is(CommandView) then
    return old_on_key_pressed(k, ...)
  else
    handle_keystroke(stroke)
    return true
  end

  return true
end

-- ----------------------------------------------------------------------------
