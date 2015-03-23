
h = dofile('fun.lua')

client={}
function client:close()
    print('closed')
end
function client:send(msg)
    print(msg)
end


h(client,req)
