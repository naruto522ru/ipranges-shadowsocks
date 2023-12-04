#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/naruto522ru/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'spotify' || echo 'failed'

# save ipv4
grep -v ':' /tmp/spotify.txt | sed 's/\/32//g' > /tmp/spotify-ipv4.txt

# save ipv6
#grep ':' /tmp/spotify.txt > /tmp/spotify-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee spotify/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee spotify/ipv6.acl

# sort & uniq
sort -h /tmp/spotify-ipv4.txt | uniq >> spotify/ipv4.acl
#sort -h /tmp/spotify-ipv6.txt | uniq >> spotify/ipv6.acl
