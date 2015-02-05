#!/usr/bin/lua
require("uci")
require("socket")
require("io")
require("math")

function sleep(n)
    -- os.execute("sleep " .. tonumber(n))
    socket.sleep(n)
end

port = io.open('/dev/ttyUSB0','wb')
--port = io.open('/root/derp','wb')
numled= 3

-- x = uci.cursor(nil, "/var/state")
x = uci.cursor()
--          filename in /etc/config
--                   section name (second param in 'config type name' )
--                            option
current_mode = x:get("colors","colors","mode")
enabled = x:get("colors","colors","enabled")
function write_colors(colors)
  -- triples of rgb 
  port:write('BUTT')
  for i, c in ipairs(colors) do
    port:write(string.char(c[0]),
               string.char(c[1]),
               string.char(c[2]))
  end
  port:flush()
end

-- initialize colors buffer
colors = {}
for i=1,numled do
  colors[i]={}
end



while true do
  -- x = uci.cursor(nil, "/var/state")
  x = uci.cursor()
  mode= x:get("colors","colors","mode")
  enabled = x:get("colors","colors","enabled")
  if enabled == '0' then
    print("off")
    for i=1,numled do
      colors[i][0]= 0
      colors[i][1]= 0
      colors[i][2]= 0
    end
    write_colors(colors)
    sleep(1)
  elseif mode == "white" then
    print("white")
    for i=0,numled do
      colors[i][0]= 0
      colors[i][1]= 0
      colors[i][2]= 0
    end
    write_colors(colors)
    sleep(1)
  elseif mode == "rainbow" then
    print("rainbow")
    sleep(1)
  elseif mode == "random" then
    print("random")
    for i=1,numled do
      colors[i][0]= math.random(255)
      colors[i][1]= math.random(255)
      colors[i][2]= math.random(255)
    end
    write_colors(colors)
    sleep(10)
  else
    print("unknown mode" .. mode)
  end

  current_mode=mode
end
