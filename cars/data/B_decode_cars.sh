#!/bin/sh
for d in ./[0-9]* ; do
    if [ ! -f $d/car.decoded -o ! -f $d/car.dump ] ; then
        echo "Decoding $d"
        ( cd $d;
          ../../../haskell/car2solver < car.def > car.decoded
          ../../../haskell/cardump < car.def > car.dump
        )
    fi
done
