#!/bin/bash
# Written by Marc Young
# Curls sites from a for loop that reads from a file with site URLs.
# The results are put in an output file.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT="$DIR"/output\.txt

grep -v '^ *#' < "$DIR"/query\.txt | while IFS= read -r i
do
    content="$(curl -s  "$i" | grep -i "<title>")"
    if [ -n "$content"  ]; then
      {
        date +%Y-%m-%d:%H:%M:%S
        echo "${content// /}" 
        echo " " 
      } >> "$OUTPUT"
    else
      {
        date +%Y-%m-%d:%H:%M:%S
        echo "No results" 
      } >> "$OUTPUT"
    fi
done

{
  printf "%b\\n" "Your IP According to HostGator: $(curl -s https://www.hostgator.com/ip | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/[^0-9.]//g')" 

  printf "%b\\n" "Your IP According to IPChicken: $(curl -s https://ipchicken.com/  | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1 | sed 's/[^0-9.]//g')" 

  printf "%b\\n" "Your IP According to the dig command: $(dig +short myip.opendns.com @resolver1.opendns.com)" 

  printf "%b\\n" "\\n++++++++++++++++++" ""
} >> "$OUTPUT"

mkdir -p "$DIR"/log

minimumsize=100000
actualsize=$(wc -c < "$OUTPUT")

if [ "$actualsize" -ge "$minimumsize" ]; then
     gzip "$OUTPUT"
     mv "$OUTPUT".gz "$DIR"/log/"$(date +%F-%T)".gz
else
	exit 0
fi

if grep -Fxq "No results" "$OUTPUT"; then
  echo "It appears as though the sites couldn't be curled." 
fi