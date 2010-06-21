#!/bin/sh
for d in ./[0-9]* ; do
    if [ ! -f $d/car.fuel -a -s $d/car.fuel_formula ] ; then
        echo "Encoding $d"
        ( cd $d;
          ../../../haskell/encode-fuel < car.fuel_formula | ../../../haskell/trits2factory > car.fuel
        )
    fi
done
