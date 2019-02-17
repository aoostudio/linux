#!/bin/bash
# Aoo Chk IP In Range wrapper # Version 1.0.0.3
# Script Developed by Apivat Pattana-Anurak
# Example : sh biss_ip.sh 27.254.164.1

############################## : Chk IP Validation (Range)################################
# Set DEBUG=1, in order to see it iterate through the calculations.
#DEBUG=1

MAXCDN_ARRAY="27.254.164.0/24 27.254.165.0/24 27.254.166.0/24 27.254.167.0/24 27.254.216.0/24 103.233.192.0/24 103.233.193.0/24 103.233.194.0/24 103.70.4.0/24 103.70.5.0/24 103.70.6.0/24 103.70.7.0/24 43.255.240.0/24 43.255.241.0/24 43.255.242.0/24 43.255.243.0/24"

IP=$1

function in_subnet {
    # Determine whether IP address is in the specified subnet.
    #
    # Args:
    #   sub: Subnet, in CIDR notation.
    #   ip: IP address to check.
    #
    # Returns:
    #   1|0
    #
    local ip ip_a mask netmask sub sub_ip rval start end

    # Define bitmask.
    local readonly BITMASK=0xFFFFFFFF

    # Set DEBUG status if not already defined in the script.
    [[ "${DEBUG}" == "" ]] && DEBUG=0

    # Read arguments.
    IFS=/ read sub mask <<< "${1}"
    IFS=. read -a sub_ip <<< "${sub}"
    IFS=. read -a ip_a <<< "${2}"

    # Calculate netmask.
    netmask=$(($BITMASK<<$((32-$mask)) & $BITMASK))

    # Determine address range.
    start=0
    for o in "${sub_ip[@]}"
    do
        start=$(($start<<8 | $o))
    done

    start=$(($start & $netmask))
    end=$(($start | ~$netmask & $BITMASK))

    # Convert IP address to 32-bit number.
    ip=0
    for o in "${ip_a[@]}"
    do
        ip=$(($ip<<8 | $o))
    done

    # Determine if IP in range.
    (( $ip >= $start )) && (( $ip <= $end )) && rval=1 || rval=0

    (( $DEBUG )) &&
        printf "ip=0x%08X; start=0x%08X; end=0x%08X; in_subnet=%u\n" $ip $start $end $rval 1>&2

    echo "${rval}"
}

for subnet in $MAXCDN_ARRAY
do
    (( $(in_subnet $subnet $IP) )) &&
        echo "IP : ${IP} Is in Range : ${subnet}" && break
done

############################# End Script ###############################
