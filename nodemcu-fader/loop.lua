local tmr_id=1
local running=false
local end_callback=nil

local function register_end_callback(callback)
    end_callback= callback
end

local function stop_loop()
    tmr.stop(tmr_id)
    if end_callback then end_callback(current_step) end
end

local function delay_loop(current_step, max_step, increment, delay, callback)
    if current_step > max_step then 
        print("finished loop")
        if end_callback then 
          print("running callback")
          end_callback(current_step) 
        end
    else
        callback(current_step)
        tmr.alarm(tmr_id,delay,function() delay_loop(current_step+increment,max_step,increment,delay,callback) end )
    end
end

local function get_running()
    return running
end

return {
    on_finished=register_end_callback,
    start=delay_loop,
    stop=stop_loop }
