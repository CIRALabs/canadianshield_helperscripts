# Check Digs

**Warning: This script took about 18h to run - there's a lot of hosts to look up**

To use this script, one must first download the hosts lists from [StevenBlack's hosts list](https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts).
The file must be stripped of all ip entries (0.0.0.0) and comments to establish it as a simple csv of hostnames.

```bash
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
sed -i 's/^0.0.0.0 //; /^#.*$/d; /^ *$/d; s/\t*//g' hosts # (Remove '0' IPs; comments, empty space lines, and tabs)
sed -i '1,14d' hosts # (I deleted the first 14 lines here as they were all 'localhost' entries).
```

**Note: when the script starts, all previous logged entries will be lost, be sure to make copies of the output files and save them if you want to reference them later.**

White processing, in order to reassure the user that it is indeed still running, it prints the current processing line every 100 lines.

Upon execution, the script will first check with Cloudflare (1.1.1.1) to verify that the domain still exists. If it does not exist, then the domain is logged to 'nondomains.csv'.

If the domain exists, then the domain is checked against 4 other DNS servers:
1. Cloudflare family (1.1.1.2)
2. Quad 9 (9.9.9.9)
3. CIRA Canadian Shield Private (149.112.121.10)
4. CIRA Canadian Shield Protected (149.112.121.20)

All domains that are blocked by any of the DNS servers are logged to their CSV file
1. cloudflare_blocks.csv
2. quadnine_blocks.csv
3. cdnshield_priv_blocks.csv
4. cdnshield_prot_blocks.csv

Once complete, the script performs a `wc -l` to count how many domains were blocked by each DNS server.

