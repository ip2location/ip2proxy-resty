# Quickstart

## Dependencies

This library requires IP2Proxy BIN database to function. You may download the BIN database at

-   IP2Proxy LITE BIN Data (Free): <https://lite.ip2location.com>
-   IP2Proxy Commercial BIN Data (Comprehensive):
    <https://www.ip2location.com>

## Installation

```
opm get ip2location/ip2proxy-resty
```

## Sample Codes

### Query geolocation information from BIN database

You can query the geolocation information from the IP2Proxy BIN database as below:

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