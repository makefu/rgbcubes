dofile('wifi.lc')(
  -- onSuccess
  function ()
    print('completed')
    dofile('mybox.lc')
    dofile('fadesrv.lua')
  end,
  -- onFailure
  function ()
    node.restore()
    node.restart()
  end
  )
