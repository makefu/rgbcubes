c = require('config')
return function(onSuccess, onFailure)

  local function fallbackAP()
    print("starting enduser")
    ws2812.write(1,string.char(0,0,0))
    ws2812.write(1,string.char(0,255,0))
    enduser_setup.start()
  end

  wifi.setmode(wifi.STATION)

  wifi.sta.eventMonReg(wifi.STA_WRONGPWD, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_FAIL, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_GOTIP, function ()
    wifi.sta.eventMonStop("unreg all")
    c.state.wifi_ssid,c.state.wifi_pw,_,_ = wifi.sta.getconfig()
    print(c.state.wifi_pw)
    print("saving new config")
    c:save()
    print("Callback onSuccess")
    onSuccess()
  end)
  wifi.sta.eventMonStart()

  wifi.sta.config(c.state.wifi_ssid,c.state.wifi_pw)


end
