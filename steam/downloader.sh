#!/bin/bash

set -euo pipefail
set -x

# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'steam' || echo 'failed'

# save ipv4
grep -v ':' /tmp/steam.txt | sed 's/\/32//g' > /tmp/steam-ipv4.txt

# save ipv6
#grep ':' /tmp/steam.txt > /tmp/steam-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee steam/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee steam/ipv6.acl

# Paste domain in ACL list
for domain in $(cat steam/domain.txt | sed 's/\./\\./g'); do echo \(\?\:\^\|\\\.\)${domain}$ >> steam/ipv4.acl; done

# sort & uniq
sort -h /tmp/steam-ipv4.txt | uniq >> steam/ipv4.acl
#sort -h /tmp/steam-ipv6.txt | uniq >> steam/ipv6.acl
