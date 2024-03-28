#!/usr/bin/env bash
set -e -u

# This script toggles the PulseAudio sink in use.
ALL_SINKS=$(wpctl status | 
    awk '/Audio/{f=1} /Video/{f=0;print} f' | 
    awk '/Sinks:/{f=1} /Sink endpoints:/{f=0;print} f' |
    sed -En "s/.* ([0-9]+)\. .*/\1/p" |
    sort -n)

ACTIVE_SINK=$(wpctl status | 
    awk '/Audio/{f=1} /Video/{f=0;print} f' | 
    awk '/Sinks:/{f=1} /Sink endpoints:/{f=0;print} f' |
    sed -En "s/.*\*.* ([0-9]+)\. .*/\1/p")

echo "Active sink is: $ACTIVE_SINK"

SET_TO_SINK=${ALL_SINKS[0]}
for v in ${ALL_SINKS[@]}; do
    if (( $v > $ACTIVE_SINK )); then 
        SET_TO_SINK=$v;
        break;
    fi; 
done

echo "Will set to sink $SET_TO_SINK"
wpctl set-default $SET_TO_SINK