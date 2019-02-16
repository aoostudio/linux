#!/bin/bash
# Aoo validate_ip wrapper # Version 1.0.0.1
# Script Developed by Apivat Pattana-Anurak
# Checks that the parameter passed is an IP Address.
# Meant for user input validation.

function validate_IP() {
        # Step 1 : Contain exactly three dots.
if [ `echo $1 | grep -o '\.' | wc -l` -ne 3 ]; then
        echo "Parameter '$1' does not look like an IP Address (does not contain 3 dots).";
        exit 1;
        # Step 2 : Contain exactly four parts, if broken down by dots.
elif [ `echo $1 | tr '.' ' ' | wc -w` -ne 4 ]; then
        echo "Parameter '$1' does not look like an IP Address (does not contain 4 octets).";
        exit 1;
else       
        # 3 All four parts are numeric.
        for OCTET in `echo $1 | tr '.' ' '`; do
                if ! [[ $OCTET =~ ^[0-9]+$ ]]; then
                        echo "Parameter '$1' does not look like in IP Address (octet '$OCTET' is not numeric).";
                        exit 1;   
        # Step 4 : All four parts are between 0 and 255.
                elif [[ $OCTET -lt 0 || $OCTET -gt 255 ]]; then
                        echo "Parameter '$1' does not look like in IP Address (octet '$OCTET' is not in range 0-255).";
                        exit 1;
                fi
        done
fi

echo "Parameter '$1' is a valid IP Address.";
return 0;
}

validate_IP $1;
