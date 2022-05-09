#!/bin/sh

xmllint \
  --html \
  --noblanks \
  --xpath '//*[@id="search"]/div[1]/div[1]/div/span[3]/div[2]/div[2]/div/div/div/div/div/div[2]/div/div/div[1]/h2/a/span/text()' \
  $1 \
  2>/dev/null
