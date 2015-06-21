c = require('config')
wifi.setmode(wifi.STATION)
wifi.sta.config(c.state.wifi_ssid,c.state.wifi_pw)

-- TODO: implement fallback
