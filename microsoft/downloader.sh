#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'microsoft' || echo 'failed'

# save ipv4
grep -v ':' /tmp/microsoft.txt | sed 's/\/32//g' > /tmp/microsoft-ipv4.txt

# save ipv6
#grep ':' /tmp/microsoft.txt > /tmp/microsoft-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee microsoft/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee microsoft/ipv6.acl

# sort & uniq
sort -h /tmp/microsoft-ipv4.txt | uniq >> microsoft/ipv4.acl
#sort -h /tmp/microsoft-ipv6.txt | uniq >> microsoft/ipv6.acl
