# dnsdig

## Description
A little script using `dig` or `drill` to measure response times of DNS resolvers.

## Usage

##### Local

Save, mark executable, run.
```
curl -O https://raw.githubusercontent.com/Vudubond/dnsresolver/main/dnsresolver.sh
```
```
chmod +x dnsresolver.sh
```
```
./dnsresolver.sh
```

##### Remote

The script can be used directly from this source.

```
bash <(curl -s https://raw.githubusercontent.com/Vudubond/dnsresolver/main/dnsresolver.sh)
```

##### Options

A few extra options are avilable in the form of environment variables.

`DOMAIN=any.url` Can be used to change the domain used for lookups. <br>
`TESTDNS=X.Y.Y.Z` Can be used to test a resolver IP not already featured. <br>
`SKIP=1` Will skip the preliminary message as well as all queries except $CURRENTDNS and $TESTDNS if defined. <br>



## Featured DNS


| Provider     | Primary IP   | Secondary IP |
|--------------|--------------|--------------|
| <a href=https://adguard-dns.io/public-dns.html>AdGuard</a> | 94.140.14.14 | 94.140.15.15 |
| <a href=https://cleanbrowsing.org/filters>CleanBrowsing</a> | 185.228.168.9 | 185.228.169.9 |
| <a href=https://controld.com/free-dns>Control D</a> | 76.76.2.2 | 76.76.10.2 |
| <a href=https://1.1.1.1>Cloudflare</a> | 1.1.1.1 | 1.0.0.1 |
| <a href=https://gcore.com/public-dns>Gcore</a> | 95.85.95.85 | 2.56.220.2 |
| <a href=https://developers.google.com/speed/public-dns>Google</a> | 8.8.8.8 | 8.8.4.4 |
| <a href=https://www.publicdns.neustar>Neustar</a> | 156.154.70.2 | 156.154.71.2 |
| <a href=https://nextdns.io>NextDNS</a> | 45.90.28.105 | 45.90.30.105 |
| <a href=https://use.opendns.com>OpenDNS</a> | 208.67.222.222 | 208.67.220.220 |
| <a href=https://www.quad9.net>Quad9</a> | 9.9.9.9 | 149.112.112.112 |

<br>
