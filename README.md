# IP2Proxy OpenResty Package

This package allows user to query an IP address if it was being used as VPN anonymizer, open proxies, web proxies, Tor exits, data center, web hosting (DCH) range, search engine robots (SES), residential proxies (RES), consumer privacy networks (CPN), and enterprise private networks (EPN). It lookup the proxy IP address from **IP2Proxy BIN Data** file. This data file can be downloaded at

* Free IP2Proxy BIN Data: https://lite.ip2location.com
* Commercial IP2Proxy BIN Data: https://www.ip2location.com/database/ip2proxy

As an alternative, this package can also call the IP2Proxy Web Service. This requires an API key. If you don't have an existing API key, you can subscribe for one at the below:

https://www.ip2location.com/web-service/ip2proxy

## Installation

```
opm get ip2location/ip2proxy-resty
```

## QUERY USING THE BIN FILE

## Functions
Below are the functions supported in this package.

|Function Name|Description|
|---|---|
|open|Open the IP2Proxy BIN data for lookup.|
|close|Close and clean up the file pointer.|
|get_package_version|Get the package version (1 to 11 for PX1 to PX11 respectively).|
|get_module_version|Get the module version.|
|get_database_version|Get the database version.|
|isproxy|Check whether if an IP address was a proxy. Returned value:<ul><li>-1 : errors</li><li>0 : not a proxy</li><li>1 : a proxy</li><li>2 : a data center IP address or search engine robot</li></ul>|
|get_all|Return the proxy information in an object.|
|get_proxytype|Return the proxy type. Please visit <a href="https://www.ip2location.com/database/px10-ip-proxytype-country-region-city-isp-domain-usagetype-asn-lastseen-threat-residential" target="_blank">IP2Location</a> for the list of proxy types supported|
|get_country_short|Return the ISO3166-1 country code (2-digits) of the proxy.|
|get_country_long|Return the ISO3166-1 country name of the proxy.|
|get_region|Return the ISO3166-2 region name of the proxy. Please visit <a href="https://www.ip2location.com/free/iso3166-2" target="_blank">ISO3166-2 Subdivision Code</a> for the information of ISO3166-2 supported|
|get_city|Return the city name of the proxy.|
|get_isp|Return the ISP name of the proxy.|
|get_domain|Return the domain name of the proxy.|
|get_usagetype|Return the usage type classification of the proxy. Please visit <a href="https://www.ip2location.com/database/px10-ip-proxytype-country-region-city-isp-domain-usagetype-asn-lastseen-threat-residential" target="_blank">IP2Location</a> for the list of usage types supported.|
|get_asn|Return the autonomous system number of the proxy.|
|get_as|Return the autonomous system name of the proxy.|
|get_lastseen|Return the number of days that the proxy was last seen.|
|get_threat|Return the threat type of the proxy.|
|get_provider|Return the provider of the proxy.|
|get_fraudscore|Return the potential risk score (0 - 99) associated with IP address.|

## Usage

```Nginx
worker_processes  1;
error_log logs/error.log;
events {
    worker_connections 1024;
}
http {
    server {
        listen 8080 reuseport;
        location / {
            default_type text/html;
            content_by_lua_block {
                ip2proxy = require('ip2proxy')
                local ip2prox = ip2proxy:open('/usr/local/ip2location/IP2PROXY-IP-PROXYTYPE-COUNTRY-REGION-CITY-ISP-DOMAIN-USAGETYPE-ASN-LASTSEEN-THREAT-RESIDENTIAL-PROVIDER-FRAUDSCORE.BIN')
                local result = ip2prox:get_all('8.8.8.8')
                ngx.say("isproxy: " .. result.isproxy)
                ngx.say("proxytype: " .. result.proxytype)
                ngx.say("country_short: " .. result.country_short)
                ngx.say("country_long: " .. result.country_long)
                ngx.say("region: " .. result.region)
                ngx.say("city: " .. result.city)
                ngx.say("isp: " .. result.isp)
                ngx.say("domain: " .. result.domain)
                ngx.say("usagetype: " .. result.usagetype)
                ngx.say("asn: " .. result.asn)
                ngx.say("as: " .. result.as)
                ngx.say("lastseen: " .. result.lastseen)
                ngx.say("threat: " .. result.threat)
                ngx.say("provider: " .. result.provider)
                ngx.say("fraudscore: " .. result.fraudscore)
                ip2prox:close()
            }
        }
    }
}

```

## QUERY USING THE IP2PROXY PROXY DETECTION WEB SERVICE

## Functions
Below are the functions supported in this package.

|Function Name|Description|
|---|---|
|open|Expects 3 input parameters:<ol><li>IP2Proxy API Key.</li><li>Package (PX1 - PX11)</li></li><li>Use HTTPS or HTTP</li></ol> |
|lookup|Query IP address. This function returns a table containing the proxy info. <ul><li>countryCode</li><li>countryName</li><li>regionName</li><li>cityName</li><li>isp</li><li>domain</li><li>usageType</li><li>asn</li><li>as</li><li>lastSeen</li><li>threat</li><li>proxyType</li><li>isProxy</li><li>provider</li><ul>|
|get_credit|This function returns the web service credit balance in a table.|

## Usage

```Nginx
worker_processes  1;
error_log logs/error.log;
events {
    worker_connections 1024;
}
http {
    resolver 8.8.8.8;
    server {
        listen 8080 reuseport;
        location / {
            default_type text/html;
            content_by_lua_block {
                local apikey = 'YOUR_API_KEY'
                local apipackage = 'PX11'
                local usessl = true
                local ip = '8.8.8.8'
                ip2proxywebservice = require('ip2proxywebservice')
                local ws = ip2proxywebservice:open(apikey, apipackage, usessl)
                local result = ws:lookup(ip)
                if result["response"] ~= nil then
                    if result.response == "OK" then
                        ngx.say("countryCode: " .. result.countryCode)
                        ngx.say("countryName: " .. result.countryName)
                        ngx.say("regionName: " .. result.regionName)
                        ngx.say("cityName: " .. result.cityName)
                        ngx.say("isp: " .. result.isp)
                        ngx.say("domain: " .. result.domain)
                        ngx.say("usageType: " .. result.usageType)
                        ngx.say("asn: " .. result.asn)
                        ngx.say("as: " .. result.as)
                        ngx.say("lastSeen: " .. result.lastSeen)
                        ngx.say("threat: " .. result.threat)
                        ngx.say("provider: " .. result.provider)
                        ngx.say("proxyType: " .. result.proxyType)
                        ngx.say("isProxy: " .. result.isProxy)
                    else
                        print("Error: " .. result.response)
                    end
                end
                local result2 = ws:get_credit()
                if result2["response"] ~= nil then
                    ngx.say("Credit Balance: " .. result2.response)
                end
            }
        }
    }
}
```