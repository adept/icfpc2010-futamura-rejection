#!/bin/sh
[ -f "$1" ] || { echo "Gimme car_data or car_data_new"; exit 1; };
sed -e "s/,//" "$1" | while read cid cdata ; do
    if [ ! -d "$cid" ] ; then 
        echo "Creating $cid"
        mkdir "$cid" && echo "$cid, $cdata" > "$cid/car.def"
    fi
done
