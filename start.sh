#!/bin/bash
set -euo pipefail
if [ -f ~/dev/config/advent-code/SESSION_COOKIE ]; then
  export SESSION_COOKIE=$(cat ~/dev/config/advent-code/SESSION_COOKIE)
fi

if [ -z ${SESSION_COOKIE:-""} ]; then
  echo "Need to set SESSION_COOKIE."
  exit 1
fi

year=2022
day=${1:-""}
if [ -z "$day" ]; then
  echo "Usage: $0 [day]"
  exit 1
fi

daily_directory_path="$(dirname $0)/$year/$(printf "%02d" $day)"
if [ ! -d $daily_directory_path ]; then
  echo "Daily directory does not exist. Copying..."
  cp -r "$(dirname $0)/directory-template" $daily_directory_path
fi

curl "https://adventofcode.com/2022/day/$(printf "%d" $day)/input" \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:107.0) Gecko/20100101 Firefox/107.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Connection: keep-alive' \
  -H "Cookie: session=$SESSION_COOKIE" > $daily_directory_path/input

tmux new -c $daily_directory_path
