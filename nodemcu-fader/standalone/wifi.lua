return function(onSuccess, onFailure)
  c = require('config')

  local function fallbackAP()
    local function saveConfig()
      c.state.wifi_ssid,c.state.wifi_pw,_,_ = wifi.sta.getconfig()
      print("saving new config")
      c.save()
    end
    enduser_setup.start(saveConfig,onFailure)
  end

  wifi.sta.eventMonStart()
  wifi.sta.eventMonReg(wifi.STA_WRONGPWD, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_FAIL, fallbackAP)
  wifi.sta.eventMonReg(wifi.STA_GOTIP, function ()
    wifi.sta.eventMonStop("unreg all")
    onSuccess()
  end)

  wifi.setmode(wifi.STATION)
  wifi.sta.config(c.state.wifi_ssid,c.state.wifi_pw)


end
