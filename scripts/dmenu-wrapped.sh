#!/usr/bin/env bash

set -e

export PATH="${HOME}/nixos/scripts:${PATH}" 

dmenu_path | dmenu -b | xargs swaymsg exec --
