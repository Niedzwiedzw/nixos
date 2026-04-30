#!/usr/bin/env bash

set -euo pipefail

swaymsg -t SUBSCRIBE -m '["workspace"]' \
  | jq --unbuffered -r 'select(.change == "focus") | .current.output' \
  | xargs -L1 swaymsg input type:tablet_tool map_to_output
