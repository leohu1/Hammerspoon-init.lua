require("lfs")
dofile(hs.configdir .. "/config.lua")
dofile(hs.configdir .. "/pomodoor.lua")
dofile(hs.configdir .. "/caffeine.lua")
-- CChooser = hs.loadSpoon('CChooser')
SpoonS = {}

-- Load those Spoons
for _, vSpoon in pairs(hspoon_list) do
    SpoonS[vSpoon] = hs.loadSpoon(vSpoon)
end

for _index,screen in pairs(hs.screen.allScreens()) do
  if screen:frame().w / screen:frame().h > 2 then
    -- 10 * 4 for ultra wide screen
    screen_x = 10
    screen_y = 4
    -- hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
  else
    if screen:frame().w < screen:frame().h then
      -- 4 * 8 for vertically aligned screen
      screen_x = 4
      screen_y = 8
      -- hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
    else
      -- 8 * 4 for normal screen
      screen_x = 8
      screen_y = 4
      -- hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
    end
  end
  hs.grid.setGrid(string.format('%d * %d', screen_x, screen_y), screen)
end

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

hs.hotkey.bind(hspoon_key, "A", function()
  SpoonS['CChooser'].hsys_choices = nil

  hsys_chose = {
    {text = "Sleep", subText = 'command', todo = function ()
        hs.caffeinate.systemSleep()
      end
    },
    {text = "LogOut", subText = 'command', todo = function ()
        hs.caffeinate.logOut()
      end
    },
    {text = "RestartSystem", subText = 'command', todo = function ()
        hs.caffeinate.restartSystem()
      end
    },
    {text = "ShutdownSystem", subText = 'command', todo = function ()
        hs.caffeinate.shutdownSystem()
      end
    },
    {text = "LockScreen", subText = 'command', todo = function ()
        hs.caffeinate.lockScreen()
      end
    }
  }

  for file in lfs.dir('/Applications') do
    if file:sub(-4) == ".app" then
            hsys_chose[#hsys_chose + 1] =  {text = file:sub(1, -5), subText = 'App', todo = function ()
              hs.application.open(file:sub(1, -5))
            end
             }
      end
  end

  SpoonS['CChooser'].hsys_choices = hsys_chose
  SpoonS['CChooser'].color = {green = 1, red = 0.65, blue = 1, alpha = 1}
  SpoonS['CChooser'].show()
  hsys_chose = nil
end)

hs.notify.new({title="Hammerspoon", informativeText="reload"}):send()
