local cjson = require "cjson"
local http = require "resty.http"
local httpc = http.new()

-- for debugging purposes
-- local function printme(stuff)
  -- local inspect = require('inspect')
  -- print(inspect(stuff))
-- end

ip2proxywebservice = {
  apikey = "",
  apipackage = "",
  usessl = false
}
ip2proxywebservice.__index = ip2proxywebservice

ip2proxyresult = {
  response = '',
  countryCode = '',
  countryName = '',
  regionName = '',
  cityName = '',
  isp = '',
  proxyType = '',
  isProxy = '',
  domain = '',
  usageType = '',
  asn = '',
  as = '',
  lastSeen = '',
  threat = '',
  provider = ''
}
ip2proxyresult.__index = ip2proxyresult

-- initialize the component with the web service configuration
function ip2proxywebservice:open(apikey, apipackage, usessl)
  local x = {}
  setmetatable(x, ip2proxywebservice)  -- make ip2proxywebservice handle lookup

  x.apikey = apikey
  x.apipackage = apipackage
  x.usessl = usessl

  return x
end

-- main query
function ip2proxywebservice:lookup(ipaddress)
  local protocol = "http"
  if self.usessl then
    protocol = "https"
  end
  
  local jsonstr = "{}"
  local res, err = httpc:request_uri(protocol .. "://api.ip2proxy.com/?key=" .. ngx.escape_uri(self.apikey) .. "&package=" .. ngx.escape_uri(self.apipackage) .. "&ip=" .. ngx.escape_uri(ipaddress), { method = "GET", ssl_verify = false })
  if res then
    jsonstr = res.body
  end
  local result = cjson.decode(jsonstr)
  setmetatable(result, ip2proxyresult)

  return result
end

-- check web service credit balance
function ip2proxywebservice:get_credit()
  local protocol = "http"
  if self.usessl then
    protocol = "https"
  end
  
  local jsonstr = "{}"
  local res, err = httpc:request_uri(protocol .. "://api.ip2proxy.com/?key=" .. ngx.escape_uri(self.apikey) .. "&check=true", { method = "GET", ssl_verify = false })
  if res then
    jsonstr = res.body
  end
  local result = cjson.decode(jsonstr)
  setmetatable(result, ip2proxyresult)

  return result
end

return ip2proxywebservice
