#!/usr/bin/env bash

layout=$(setxkbmap -query | awk '/layout:/ {print $2}')

if [ "$layout" = "br" ]; then
    setxkbmap gr -variant polytonic
else
    setxkbmap br
fi
