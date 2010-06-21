#!/bin/sh
#python2.6 ./data/submit_fuel.py listcars > ./data/car_ids
#python2.6 ./data/submit_fuel.py loadcars > ./data/car_data_new
./fetch.pl > ./data/car_data_new
cd data
./cycle.sh
# TODO: add decode-solve-run cycle here
