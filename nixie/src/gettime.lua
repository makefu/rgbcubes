-- ATTENTION: unix2date only works correctly with INTEGER nodemcu firmware!

-- origin timzeone berlin (not dst)
local otz = 1
local tz = otz
local hour = 0
local min = 0
local seconds = 0
local year = 1970
local month = 1
local day = 1
-- local floor = math.floor

-- we retrieve our current timezone offset
local ntpserver = "time.nist.gov"
local function init()
  print("init display")
  local sda = 1
  local scl = 2
  local sla = 0x3c
  i2c.setup(0, sda, scl, i2c.SLOW)
  disp = u8g.ssd1306_128x64_i2c(sla)
  disp:setFont(u8g.font_6x10)
end


local function draw()
  disp:drawStr(0,10, "--===Nixie Clock===--")
  disp:drawStr(0,25,string.format("%d-%02d-%02d   %02d:%02d:%02d",year,month,day,hour,min,seconds))
  -- disp:drawStr(0,35,string.format(,))
  disp:drawStr(0,58,string.format("(UTC%s%d)    DST: %s",
    (tz > 0) and "+" or "", tz,
    (otz == tz) and "false" or "true"))
end


local function sync_time()
  print("syncing time")
  sntp.sync(ntpserver)
end


-- implements https://stackoverflow.com/questions/5590429/calculating-daylight-saving-time-from-only-date
local function isDST(day,month,dow)
  if (month < 3 or month > 11 ) then return false end
  if (month > 3 and month < 11 ) then return true end
  local previousSunday = day - dow;
  if (month == 3) then return previousSunday >= 8 end
  return previousSunday <= 0
end

-- return h, m, s, Y, M, D, W (0-sun, 6-sat)
local function unix2date(t)
    local jd, f, e, h, y, m, d
    jd = t / 86400 + 2440588
    f = jd + 1401 + (((4 * jd + 274277) / 146097) * 3) / 4 - 38
    e = 4 * f + 3
    h = 5 * ((e % 1461) / 4) + 2
    d = (h % 153) / 5 + 1
    m = (h / 153 + 2) % 12 + 1
    y = e / 1461 - 4716 + (14 - m) / 12
    return (t%86400)/3600, (t%3600)/60, t%60, y, m, d, (jd+8)%7
end

-- get the latest time every day or at restart
local function refresh_data()
  local sec,usec = rtctime.get()
  local _,_,_,_,m,d,dow = unix2date(sec)

  tz = isDST(d,m,dow) and (otz + 1) or otz

  hour,min,seconds,year,month,day,_ = unix2date(sec + (tz * 3600))
end

local function show()
  if not disp then init() end
  refresh_data()
  disp:firstPage()
  repeat draw()
  until disp:nextPage() == false
end

local function schedule(tid)
  tmr.alarm(tid or 6, 500, tmr.ALARM_AUTO,function() show() end)
end

sync_time()

return {init=init,sync=sync_time,show=show,schedule=schedule}
