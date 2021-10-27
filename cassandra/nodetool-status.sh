#!/bin/bash

_ip_address() {
        # scrape the first non-localhost IP address of the container
        # in Swarm Mode, we often get two IPs -- the container IP, and the (shared) VIP, and the container IP should always be first
        ip address | awk '
                $1 != "inet" { next } # only lines with ip addresses
                $NF == "lo" { next } # skip loopback devices
                $2 ~ /^127[.]/ { next } # skip loopback addresses
                $2 ~ /^169[.]254[.]/ { next } # skip link-local addresses
                {
                        gsub(/\/.+$/, "", $2)
                        print $2
                        exit
                }
        '
}

# put it into a variable.
MY_IPADDRESS="$(_ip_address)"

# now call nodetool status
# and pipe THAT looking for UN.
output=`nodetool status | grep "${MY_IPADDRESS}"`
return_value=`echo "${output}" | grep -c UN`

# output to screen
echo "${output}"

if test $return_value -eq 1;
then    
    exit 0
else
    exit 2
fi



