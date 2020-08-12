-- local path = os.getenv("HOME") .. "/.hammerspoon/lfs.so"
require("lfs")
-- lfs = package.loadlib(path, "luaopen_lfs")()
dofile(os.getenv("HOME") .. "/.hammerspoon/config.lua")
dofile(os.getenv("HOME") .. "/.hammerspoon/pomodoor.lua")
dofile(os.getenv("HOME") .. "/.hammerspoon/caffeine.lua")
for _index,screen in pairs(hs.screen.allScreens()) do
  if screen:frame().w / screen:frame().h > 2 then
    -- 10 * 4 for ultra wide screen
    screen_x = 10
    screen_y = 4
    hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
  else
    if screen:frame().w < screen:frame().h then
      -- 4 * 8 for vertically aligned screen
      screen_x = 4
      screen_y = 8
      hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
    else
      -- 8 * 4 for normal screen
      screen_x = 8
      screen_y = 4
      hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
    end
  end
end

function completionFn(text)
  print(text["uuid"])
  hs.application.open(text["uuid"])
end

-- hspoon_list = config.hspoon_list
--
-- hspoon_key = config.hspoon_key

-- Load those Spoons
for _, vSpoon in pairs(hspoon_list) do
    hs.loadSpoon(vSpoon)
end

-- hsapp_list = config.hsapp_list

for _, v in ipairs(happ_list) do
    if v.id then
      hs.hotkey.bind(hspoon_key, v.key, function()
        -- hs.application.open(hs.application:bundleID(v.id))
        -- hs.application:bundleID(v.id)
        hs.application.open(v.id)
      end)
    elseif v.name then
        hs.hotkey.bind(hspoon_key, v.key, function()
          -- hs.application.open(hs.application:bundleID(v.id))
          -- hs.application:bundleID(v.id)
          hs.application.open(v.name)
      end)
    end
end

hs.hotkey.bind(hspoon_key, "M", function()
  local win = hs.window.focusedWindow()
  hs.grid.maximizeWindow(win)
end)

hs.hotkey.bind(hspoon_key, "C", function()
  local win = hs.window.focusedWindow()
  win:centerOnScreen(win:screen())
end)

hs.hotkey.bind(hspoon_key, "[", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', 0, 0, screen_x / 2, screen_y / 2), win:screen())
end)

hs.hotkey.bind(hspoon_key, "]", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', screen_x / 2, 0, screen_x / 2, screen_y / 2), win:screen())
end)

hs.hotkey.bind(hspoon_key, ";", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', 0, screen_y / 2, screen_x / 2, screen_y / 2), win:screen())
end)

hs.hotkey.bind(hspoon_key, "'", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', screen_x / 2, screen_y / 2, screen_x / 2, screen_y / 2), win:screen())
end)

hs.hotkey.bind(hspoon_key, "Up", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', 0, 0, screen_x, screen_y / 2), win:screen())
end)

hs.hotkey.bind(hspoon_key, "down", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', 0, screen_y / 2, screen_x, screen_y), win:screen())
end)

hs.hotkey.bind(hspoon_key, "Right", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', screen_x / 2, 0, screen_x / 2, screen_y), win:screen())
end)

hs.hotkey.bind(hspoon_key, "Left", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, string.format('%d,%d %dx%d', 0, 0, screen_x / 2, screen_y), win:screen())
end)

hs.hotkey.bind(hspoon_key, "R", function()
  hs.reload()
end)

hs.hotkey.bind(hspoon_key, "T", function()
  local choices = {}
  for file in lfs.dir('/Applications') do
    if file:sub(-4) == ".app" then
            choices[#choices + 1] =  { ["text"] = file:sub(1, -5), ["uuid"] = file:sub(1, -5) }
      end
  end
  cs = hs.chooser.new(completionFn)
  cs:choices(choices)
  cs:show()
end)

hs.notify.new({title="Hammerspoon", informativeText="reload"}):send()
