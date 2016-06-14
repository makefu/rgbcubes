gpio.mode(8, gpio.OUTPUT)
gpio.mode(6, gpio.OUTPUT)
gpio.mode(7, gpio.OUTPUT)
gpio.write(8,gpio.LOW)
gpio.write(6,gpio.LOW)
gpio.write(7,gpio.LOW)

dofile('wifi.lc')(
  -- onSuccess
  function ()
    print('completed')
    dofile('mybox.lc')
    dofile('fadesrv.lc')
    dofile('gettime.lc').schedule()
  end,
  -- onFailure
  function ()
    node.restore()
    node.restart()
  end
  )
