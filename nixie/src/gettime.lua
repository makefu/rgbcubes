-- local c = require('config')
local tz = "berlin"

-- we retrieve our current timezone offset
local url = "http://www.convert-unix-time.com/api?format=iso8601&timestamp=now&timezone="..tz
local ntpserver = "time.nist.gov"
local function init()
  local sda = 2
  local scl = 1
  local sla = 0x3c
  i2c.setup(0, sda, scl, i2c.SLOW)
  disp = u8g.ssd1306_128x64_i2c(sla)
  disp:setFont(u8g.font_6x10)
end


local function draw()
  disp:drawStr(0,20,day)
  disp:drawStr(0,40,hour)
end

local function show()
  if not disp then init() end

  disp:firstPage()
  repeat draw()
  until disp:nextPage() == false
end

local function sync_time()
  sntp.sync(ntpserver)
  http.get(url,nil,function (code,data)
    ret = cjson.decode(data)
    local _,_,year,month,day,hour,min,sec,tzdir,tzh,tzm = string.find(ret.localDate,"([0-9-]+)T([0-9:]+)([+-])(.+):(.+)")
    tz = tonumber(tzh)*3600 + tonumber(tzm) * 60
    if tzdir == "-" then tz = -1 * tz end
  end)
end

local function unix2date(t)
    local jd, f, e, h, y, m, d
    jd = t / 86400 + 2440588
    f = jd + 1401 + (((4 * jd + 274277) / 146097) * 3) / 4 - 38
    e = 4 * f + 3
    h = 5 * ((e % 1461) / 4) + 2
    d = (h % 153) / 5 + 1
    m = (h / 153 + 2) % 12 + 1
    y = e / 1461 - 4716 + (14 - m) / 12
    return t%86400/3600, t%3600/60, t%60, y, m, d, jd%7+1
end

-- get the latest time every day or at restart
local function schedule()
  local sec,usec = rtctime.get()
  print(unix2date(sec + tz))
end

return {init=init,sync=sync_time,show=show,schedule}
