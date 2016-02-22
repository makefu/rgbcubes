-- on successful wifi: start the fadesrv
dofile('wifi.lc')(
  function ()
    dofile('fadesrv.lc')
  end,
  node.restart)
