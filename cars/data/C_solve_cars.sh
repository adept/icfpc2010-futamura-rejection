#!/bin/sh
for d in ./[0-9]* ; do
    if [ ! -s $d/car.fuel_formula -o \( -f $d/car.fuel_test -a ! -f $d/car.fuel_ok \) ] ; then
        ( cd $d;
          if [ -f car.fuel_test -a ! -f car.fuel_ok ] ; then
            echo "Re-solving $d"
            rm car.fuel_formula car.fuel_scalar car.fuel car.fuel_test
          fi
          if [ ! -f car.fuel_scalar ] ; then
            echo "Solving $d"
            ../../../haskell/fuel-bruteforce < car.def > car.fuel_formula || rm car.fuel_formula
            touch car.fuel_scalar
          fi
          # TODO: plug more solvers here
        )
    else 
        touch $d/car.fuel_scalar
    fi
done
