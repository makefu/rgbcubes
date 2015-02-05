module("luci.controller.colors.index", package.seeall)

function index()
  entry({"colors","template"},template("colors/herp"),"derpi template",20).dependent=false
  entry({"click","here","now"  },call("action_tryme"),"click here",10   ).dependent=false
  entry({"colors","config"},cbi("colors/myform"),"configure",0).dependent=false
end

function action_tryme()
	luci.http.prepare_content("text/plain")
	luci.http.write("herp derp")
end
