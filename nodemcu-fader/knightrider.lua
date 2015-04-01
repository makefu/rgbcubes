-- init
local numleds=7
local buffer=string.char(0,0,0):rep(numleds)
-- loop = require('loop')
-- f = require('fade')
f = {fade=function() end}

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
  buffer = table.concat{buffer:sub(1,pos-1), color, buffer:sub(pos+1)}
end

local function show()
  print(buffer:byte(1,#buffer))
end



local function knightRider(delay,decay_val,color)
  -- start here
  for i=0,numleds-1 do
    decay(decay_val)
    b=(i*3)+1
    refresh(b,color:sub(1,1))
    refresh(b+1,color:sub(2,2))
    refresh(b+2,color:sub(3,3))
    show()
  end
  -- and back
  for i=numleds-1,0,-1 do
    decay(decay_val)
    b=(i*3)+1
    refresh(b,color:sub(1,1))
    refresh(b+1,color:sub(2,2))
    refresh(b+2,color:sub(3,3))
    show()
  end
end
knightRider(10,50,string.char(0,255,0))
