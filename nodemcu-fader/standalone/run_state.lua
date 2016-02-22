local c = require('config')
local f = require('fade')
f.set_ledpin(c.state.pin)

local function run_state(nstate,data)
    local state = c.state
    ws2812.set_brightness(state.brightness)
    --print(state.pin,state.numled,state.brightness)
    if nstate == "on" then
        state.mode=nstate
        state.current= state.on_color:rep(state.numled)
        f.fade(state.current,
               state.fade_speed,state.fade_steps)

    elseif nstate == "off" then
        state.mode=nstate
        state.current= state.off_color:rep(state.numled)

        f.fade(state.current,
                    state.fade_speed,state.fade_steps)

    elseif nstate == "brightness" then
        if not data then return "failed"  end

        state.brightness = data
        ws2812.set_brightness(data)
        -- if no data is set, then use the default on color
        if not state.current then
            state.current = state.on_color:rep(state.numled)
        end
        f.fade(state.current,
               state.fade_speed,state.fade_steps)

    elseif nstate == "single" then
        if not data then return "failed"  end
        state.mode=nstate
        state.current=data:rep(state.numled)
        f.fade(state.current,
                   state.fade_speed,state.fade_steps)
    else
        print("unknown state "..nstate.." with data "..(data or "NO DATA"))
    end
    --print(state or "no state given")
    --print(state.current:byte(1,3) or "no current data")
end

return {run_state=run_state}
