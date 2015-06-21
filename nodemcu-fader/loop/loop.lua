local Timer ={running=false}
Timer.__index = Timer
setmetatable(Timer, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Timer.new(ident)
  local self= setmetatable({},Timer)
  -- tmr_id defaults to 1
  if ident then self.tmr_id = ident else self.tmr_id = 1 end
  return self
end

function Timer:on_finished(callback)
    self.end_callback= callback
end

function Timer:stop()
    tmr.stop(self.tmr_id)
    if self.end_callback then self.end_callback(self.current_step) end
end

function Timer:loop(current_step, max_step, increment, delay, callback)
    self.current_step = current_step
    if (increment > 0 and current_step > max_step) or 
       (increment < 0 and current_step < max_step) then 
       if self.end_callback then
          self.end_callback(self.current_step) 
        end
    else
        callback(current_step)
        tmr.alarm(self.tmr_id,delay,
          function() self:loop(current_step+increment,max_step,increment,delay,callback) end )
    end
end

function Timer:get_running()
    return self.running
end

function Timer:get_current_step()
  return self.current_step
end

function Timer:get_tmr_id()
  return self.tmr_id
end

function Timer:set_tmr_id(ident)
  self.tmr_id = ident
end

return Timer
