#!/bin/bash
# Written by Marc Young
# Curls sites from a for loop that reads from a file with site URLs.
# The results are put in an output file.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

grep -v '^ *#' < "$DIR"/query\.txt | while IFS= read -r i
do
    content="$(curl -s  "$i" | grep -i "<title>")"
    if [ -n "$content"  ]; then
      date +%Y-%m-%d:%H:%M:%S >> "$DIR"/output\.txt
      echo "$content" >> "$DIR"/output\.txt
    else
      date +%Y-%m-%d:%H:%M:%S >> "$DIR"/output\.txt
      echo "No results" >> "$DIR"/output\.txt
    fi
done
 
echo "" >> "$DIR"/output\.txt
echo "++++++++++++++++++" >> "$DIR"/output\.txt
echo "" >> "$DIR"/output\.txt

mkdir -p "$DIR"/log

file="$DIR"/output\.txt
minimumsize=90000
actualsize=$(wc -c <"$file")

if [ "$actualsize" -ge "$minimumsize" ]; then
     gzip "$file"
     mv "$file".gz "$DIR"/log/"$(date +%F-%T)".gz
else
	exit 0
fi

if grep -Fxq "No results" "$file"; then
  echo "It appears as though the sites couldn't be curled." 
fi