> node.compile('ntp.lua')
> node.compile('fadesrv.lua')
> require('fadesrv')
> ntp = require('ntp')
> ntp:sync(function(T) print(T:show_time()) end)
> 21:56:08
