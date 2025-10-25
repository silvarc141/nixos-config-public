#!/usr/bin/env bash

rm deb-links-result.txt > /dev/null 2>&1
while read -r line
do
  apt-get download --print-uris "$line" \
    | awk '{print $1$4}' \
    | sed -e "s/SHA256:/ /" \
    | tr -d "'" >> deb-links-result.txt
done < deb-links-package-list.txt
