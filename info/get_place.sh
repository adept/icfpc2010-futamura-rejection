#!/bin/sh
wget -q -O - http://icfpcontest.org/icfp10/score/teamAll | grep -o '<td>[^<]*</td>' | awk '/Futamura Rejection</{print NR+5}'
