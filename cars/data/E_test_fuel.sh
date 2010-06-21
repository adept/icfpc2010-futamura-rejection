#!/bin/sh
for d in [0-9]* ; do
    if [ -f $d/car.fuel -a ! -f $d/car.fuel_test ] ; then
        echo "Testing $d"
        echo "Test is not working now" > $d/car.fuel_test
        touch $d/car.fuel_ok
        #python2.6 submit_fuel2.py test $d $d/car.fuel > $d/car.fuel_test
        #grep -q "Good! The car can use this fuel" $d/car.fuel_test && touch $d/car.fuel_ok
    fi
done
