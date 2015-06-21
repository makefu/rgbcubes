-- init
local numleds=6
local buffer=string.char(0,0,0):rep(numleds)
l = require('loop').new(5)
f = require('fade')

local function decay(val)
  -- maybe even a multiplier and a static value to substract
  nbuffer=""
  for i=1,#buffer,1 do
    c=buffer:byte(i)-val
    if c < 0 then c = 0 end
    nbuffer=nbuffer..string.char(c)
  end
  buffer = nbuffer
end

local function refresh(pos, color)
  buffer = table.concat{buffer:sub(1,pos-1), color, buffer:sub(pos+#color)}
end

local function show()
  f.fade(buffer,10,5)
  
  print(node.heap())
end

local function knightRider(delay,decay_val,color)

  local function move(i)
    decay(decay_val)
    b=(i*3)+1
    refresh(b,color)
    show()
  end

  local function cb_move_down()
    l:on_finished(function ()
        knightRider(delay,decay_val,string.char(255,0,0))
        end)
    l:loop(numleds-1,0,-1,delay,move)
  end
  l:on_finished(cb_move_down)
  l:loop(0,numleds-1,1,delay,move)
  
end
knightRider(100,200,string.char(255,0,0))