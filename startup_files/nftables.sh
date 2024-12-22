#!/bin/bash

# cleanup just in case
nft flush ruleset


nft add table inet filter

# input
for i in {1..9}; do
    nft add rule inet filter input ip6 saddr fc00:2142::$i accept
done
nft add rule inet filter input ip6 saddr fc00:2142::a accept
nft add chain ip filter input '{ type filter hook input priority 0; }'
# Allow specific hosts to send packets
for i in {1..9}; do
    nft add rule inet filter input ip6 saddr fc00:2142::$i accept
done
nft add rule inet filter input ip6 saddr fc00:2142::a accept
nft add rule ip filter input drop

nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'
nft add rule inet filter input ip6 saddr fc00:2142:1::1 ip6 daddr fc00:2142:1::2 accept
nft add rule inet filter input ip6 saddr fc00:2142:1::2 ip6 daddr fc00:2142:1::1 accept
nft add rule inet filter input ip6 saddr fc00:2142:7::1 ip6 daddr fc00:2142:7::2 accept
nft add rule inet filter input ip6 saddr fc00:2142:7::2 ip6 daddr fc00:2142:7::1 accept
nft add rule inet filter input ip6 saddr fc00:2142:9::1 ip6 daddr fc00:2142:9::2 accept
nft add rule inet filter input ip6 saddr fc00:2142:9::2 ip6 daddr fc00:2142:9::1 accept
nft add rule inet filter input ip6 saddr fc00:2142:6::1 ip6 daddr fc00:2142:6::2 accept
nft add rule inet filter input ip6 saddr fc00:2142:6::2 ip6 daddr fc00:2142:6::1 accept
nft add rule inet filter input ip6 daddr ff06::178/127 accept
nft add rule inet filter input ip6 saddr ff06::178/127 accept
nft add rule inet filter input ct state established,related accept
nft add rule inet filter input iif "lo" accept


# output
nft add chain inet filter output '{ type filter hook output priority 0; policy accept; }'
nft add rule inet filter output ip6 daddr fc00:2142:1::1 accept
nft add rule inet filter output ip6 daddr fc00:2142:1::2 accept
nft add rule inet filter output ip6 daddr fc00:2142:7::1 accept
nft add rule inet filter output ip6 daddr fc00:2142:7::2 accept
nft add rule inet filter output ip6 daddr fc00:2142:9::1 accept
nft add rule inet filter output ip6 daddr fc00:2142:9::2 accept
nft add rule inet filter output ip6 daddr fc00:2142:6::1 accept
nft add rule inet filter output ip6 daddr fc00:2142:6::2 accept

for i in {1..9}; do
    nft add rule output filter input ip6 saddr fc00:2142::$i accept
done
nft add rule output filter input ip6 saddr fc00:2142::a accept

nft add rule inet filter output ip6 saddr fc00:2142:1::1 ip6 daddr ff06::178/127 accept
nft add rule inet filter output ip6 saddr fc00:2142:1::2 ip6 daddr ff06::178/127 accept
nft add rule inet filter output ip6 daddr ff06::178/127 drop
nft add rule inet filter output ip6 saddr fc00:2142:1::1 ip6 daddr ff06::178/127 accept
nft add rule inet filter output ip6 saddr fc00:2142:1::2 ip6 daddr ff06::178/127 accept

nft add rule inet filter output ct state established,related accept
nft add rule ip filter output drop

exit 0
