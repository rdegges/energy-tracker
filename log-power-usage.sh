#! /usr/bin/env bash
#
# This script logs the energy usage of this laptop by measuring how much
# wattage it is currently drawing from any attached power adapters. This
# program is meant to run once every 60 seconds in order to generate an
# accurate tally.
#
# It uses the `ioreg` CLI tool to extract the amount of power being used
# by the power adapter in watts, then divides this number by 60 to
# calculate the amount of watt-hours of electricity are being consumed.
#
# Energy usage data is stored in ~/Library/Caches/energy-tracker/energy-log.txt
#
# Author: Randall Degges
# Email: randall.degges@snyk.io
# Created: 2022-01-19

# GLOBALS
TRACKER_DIR=~/Library/Caches/energy-tracker 
TRACKER_FILE=energy-log.txt
IOREG=/usr/sbin/ioreg

# PREREQUISITES
mkdir -p ~/Library/Caches/energy-tracker

if ! command -v $IOREG &> /dev/null
then
    echo "ioreg not found"
    exit 1
fi

# Compute energy usage
wattage=`$IOREG -rw0 -c AppleSmartBattery | grep BatteryData | grep -o '"AdapterPower"=[0-9]*' | cut -c 16- | xargs -I %  lldb --batch -o "print/f %" | grep -o '$0 = [0-9.]*' | cut -c 6-`
wattHours=$(bc -l <<<"${wattage}/60")

# Only proceed if the amount of wattage being used is > 0
noWatts=$(bc -l <<<${wattage}==0)
if (( noWatts == 1 )); then
    exit
fi

uuid=`$IOREG -d2 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $(NF-1)}'`
timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"`

echo "timestamp=$timestamp wattage=$wattage wattHours=$wattHours uuid=$uuid" >> "$TRACKER_DIR/$TRACKER_FILE"
