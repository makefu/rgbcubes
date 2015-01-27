module("luci.controller.colors.new_tab",package.seeall)

function index()
  -- add new tab
  entry({"admin","colors"},firstchild(),"Colors",30).depend=false
  -- add new subsection to tab, use cbi magic
  entry({"admin","colors","cbi"},cbi("colors-config/form"),"configure",1)
end

