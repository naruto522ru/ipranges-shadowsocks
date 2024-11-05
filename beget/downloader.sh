#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'beget' || echo 'failed'

# save ipv4
grep -v ':' /tmp/beget.txt | sed 's/\/32//g' > /tmp/beget-ipv4.txt

# save ipv6
#grep ':' /tmp/beget.txt > /tmp/beget-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee beget/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee beget/ipv6.acl

# sort & uniq
sort -h /tmp/beget-ipv4.txt | uniq >> beget/ipv4.acl
#sort -h /tmp/beget-ipv6.txt | uniq >> beget/ipv6.acl
