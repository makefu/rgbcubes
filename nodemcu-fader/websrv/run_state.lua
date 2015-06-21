local c = require('config')
local f = require('fade')
f.set_ledpin(c.state.pin)

local function run_state(nstate,data)
    local state = c.state
    --print(state.pin,state.numled,state.brightness)
    if nstate == "on" then
        state.mode=nstate
        f.fade(state.on_color:rep(state.numled),
               state.fade_speed,state.fade_steps)

    elseif nstate == "off" then
        state.mode=nstate
        f.fade(state.off_color:rep(state.numled),
                    state.fade_speed,state.fade_steps)  
        
    elseif nstate == "brightness" then
        if not data then return "failed"  end
        
        state.brightness = data 
        ws2812.set_brightness(data)
        -- if no data is set, then use the default on color
        if not c.current then
            c.current = state.on_color:rep(state.numled)
        end
        f.fade(c.current,
               state.fade_speed,state.fade_steps)  
        
    elseif nstate == "single" then
        if not data then return "failed"  end
        state.mode=nstate
        f.fade(data:rep(state.numled),
                   state.fade_speed,state.fade_steps)
    else
        print("unknown state "..state.." with data "..data)
    end
end

return {run_state=run_state}
