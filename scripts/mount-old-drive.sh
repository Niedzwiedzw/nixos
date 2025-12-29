#!/usr/bin/env bash

set -e

sudo cryptsetup luksOpen /dev/nvme0n1p2 old_drive || sudo cryptsetup luksOpen /dev/nvme1n1p2 old_drive
sudo mount /dev/mapper/old_drive /old-drive
