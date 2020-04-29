# Canadian Shield helper scripts

This respository is a pseudo dumping-ground for scripts built while trying to trouble-shoot or evaluate [CIRA Canadian Shield](https://cira.ca/shield).

## Check Digs
**Warning: This script took about 18h to run - there's a lot of hosts to look up**

To use this script, one must first download the hosts lists from [StevenBlack's hosts list](https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts).
The file must be stripped of all ip entries (0.0.0.0) and comments to establish it as a simple csv of hostnames.

```bash
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
sed -i 's/^0.0.0.0 //; /^#.*$/d; /^ *$/d; s/\t*//g' hosts # (Remove '0' IPs; comments, empty space lines, and tabs)
sed -i '1,14d' hosts # (I deleted the first 14 lines here as they were all 'localhost' entries).
```
