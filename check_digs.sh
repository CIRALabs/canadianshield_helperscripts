#!/bin/bash

# To use this script, one must first download the hosts lists from https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
# The file must be stripped of all ip entries (0.0.0.0) and comments to establish it as a simple csv of hostnames.
# wget https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
# sed -i 's/^0.0.0.0 //; /^#.*$/d; /^ *$/d; s/\t*//g' hosts (Remove '0' IPs; comments, empty space lines, and tabs)
# sed -i '1,14d' hosts (I deleted the first 14 lines here as they were all 'localhost' entries).

# Warning: This script took about 18h to run - there's a lot of hosts to look up
rm nondomains.csv cdnshield_priv_blocks.csv cdnshield_prot_blocks.csv cloudflare_blocks.csv quadnine_blocks.csv 2> /dev/null
touch nondomains.csv cdnshield_priv_blocks.csv cdnshield_prot_blocks.csv cloudflare_blocks.csv quadnine_blocks.csv

index=0
while IFS= read -r line
do
  index=$(( $index + 1 ))
  if (( $index % 100 == 0 ))
  then
    echo "Processing line $index"
  fi
  
  ip=`dig +noadflag +noedns +short $line @1.1.1.1 | head -1`
  if [ "$ip" = "" ]
  then
    echo "$line" >> nondomains.csv
  else
    cdnshield_priv_ip=`dig +noadflag +noedns +short $line @149.112.121.10 | head -1`
    cdnshield_prot_ip=`dig +noadflag +noedns +short $line @149.112.121.20 | head -1`
    cloudflare_ip=`dig +noadflag +noedns +short $line @1.1.1.2 | head -1`
    quadnine_ip=`dig +noadflag +noedns +short $line @9.9.9.9 | head -1`
    
    if [ "$cdnshield_priv_ip" = "" ]
    then
      echo "$line" >> cdnshield_priv_blocks.csv
    fi
    
    # CDN Shield actually returns an IP for their block page, so we cannot expect NX Domains for blocks
    if [ "$cdnshield_prot_ip" = "" ] || [ "$cdnshield_prot_ip" = "75.2.78.236" ] || [ "$cdnshield_prot_ip" = "99.83.179.4" ] || [ "$cdnshield_prot_ip" = "99.83.178.7" ] || [ "$cdnshield_prot_ip" = "75.2.110.227" ]
    then
      echo "$line" >> cdnshield_prot_blocks.csv
    fi

    if [ "$cloudflare_ip" = "" ]
    then
      echo "$line" >> cloudflare_blocks.csv
    fi

    if [ "$quadnine_ip" = "" ]
    then
      echo "$line" >> quadnine_blocks.csv
    fi

  fi
done < "hosts"

echo "Non-Domains      : $(wc -l nondomains.csv)"
echo "CDN Shield (Priv): $(wc -l cdnshield_priv_blocks.csv)"
echo "CDN Shield (Prot): $(wc -l cdnshield_prot_blocks.csv)"
echo "Cloudflare Family: $(wc -l cloudflare_blocks.csv)"
echo "Quad 9           : $(wc -l quadnine_blocks.csv)"
