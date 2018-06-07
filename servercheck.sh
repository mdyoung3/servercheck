#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in $(cat $DIR/query\.txt); do
    content="$(curl -s "$i" | grep -i "<title>")"
    date +%Y-%m-%d:%H:%M:%S >> $DIR/output\.txt
    echo "$content" >> $DIR/output\.txt
done
