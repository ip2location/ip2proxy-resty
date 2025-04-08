# IP2Proxy OpenResty API

## IP2Proxy Class
```{py:function} open(dbpath)
Load the IP2Proxy BIN database for lookup.

:param String dbpath: (Required) The file path links to IP2Proxy BIN databases.
```

```{py:function} close()
Close and clean up the file pointer.
```

```{py:function} get_all(ipaddress)
Retrieve geolocation information for an IP address.

:param String ipaddress: (Required) The IP address (IPv4 or IPv6).
:return: Returns the geolocation information in array. Refer below table for the fields avaliable in the array
:rtype: array

**RETURN FIELDS**

| Field Name       | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| isproxy    |     Determine whether if an IP address was a proxy or not. Returns 0 is not proxy, 1 if proxy, and 2 if it's data center IP |
| country_short    |     Two-character country code based on ISO 3166. |
| country_long    |     Country name based on ISO 3166. |
| region     |     Region or state name. |
| city       |     City name. |
| isp            |     Internet Service Provider or company\'s name. |
| domain         |     Internet domain name associated with IP address range. |
| usagetype      |     Usage type classification of ISP or company. |
| asn            |     Autonomous system number (ASN). |
| as             |     Autonomous system (AS) name. |
| lastseen       |     Proxy last seen in days. |
| threat         |     Security threat reported. |
| proxytype      |     Type of proxy. |
| provider       |     Name of VPN provider if available. |
| fraudscore       |     Potential risk score (0 - 99) associated with IP address. |
```