#!/bin/sh
for d in [0-9]* ; do
    if [ -f $d/car.fuel -a -f $d/car.fuel_ok -a ! -f $d/car.fuel_uploaded ] ; then
        echo "Uploading $d"
        python2.6 submit_fuel2.py $d $d/car.fuel > $d/car.fuel_uploaded && grep "Good"  $d/car.fuel_uploaded
#        sleep 2
    fi
done
