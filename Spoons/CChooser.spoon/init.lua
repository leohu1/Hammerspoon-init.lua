--- === CChooser ===

local obj={}
obj.__index = obj

-- Metadata
obj.name = "CChooser"
obj.version = "1.0"
obj.author = "leo <2607131406@qq.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local function choicesDo(text)
  if text ~= nil
  then
    for t, v in pairs(obj.hsys_choices)
    do
      -- print(text["uuid"])
      if v['text'] == text["uuid"]
      then
        -- print(v['text'])
        v['todo']()
        break
      end
    end
  end
end

local cs = hs.chooser.new(choicesDo)

function obj:init()
  obj.color = {green = 1, red = 1, blue = 1, alpha = 1}
  obj.rows = 4
  obj.hsys_choices = {
    {text = "Sleep", todo = function ()
        hs.caffeinate.systemSleep()
      end
    },
    {text = "LogOut", todo = function ()
        hs.caffeinate.logOut()
      end
    },
    {text = "LockScreen", todo = function ()
        hs.caffeinate.lockScreen()
      end
    }
  }
end

function obj:show()
  choices = {}
  for t, v in pairs(obj.hsys_choices)
  do
    time = #choices + 1
    choices[time] =  {["text"] = v['text'], ["uuid"] = v['text'], ["subText"] = v["subText"]}
  end
  cs:choices(choices)
  cs:rows(obj.rows)
  -- hs.drawing.color.hammerspoon['osx_green']
  cs:fgColor(obj.color)
  cs:show()
end

return obj
