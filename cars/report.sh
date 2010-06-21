#!/bin/bash
cars=$(find ./data/ -name car.def -type f | wc -l)
decoded=$(find ./data -name car.decoded -type f | wc -l)
bruteforced=$(find ./data -name car.fuel_scalar -type f | wc -l)
solved=$(find ./data -name car.fuel_formula -type f | wc -l)
encoded=$(find ./data -name car.fuel -type f | wc -l)
tested=$(find ./data -name car.fuel_test -type f | wc -l)
good=$(find ./data -name car.fuel_ok -type f | wc -l)
uploaded=$(find ./data -name car.fuel_uploaded -type f | wc -l)

echo "Report on `date`"
echo "Total cars:     $cars"
echo "-------------------"
echo "Cars decoded:   $decoded"
echo "Cars bforced:   $bruteforced"
echo "Fuels solved:   $solved"
echo "Fuels encoded:  $encoded"
echo "Fuels tested:   $tested"
echo "Fuels OK:       $good"
echo "Fuels uploaded: $uploaded"
