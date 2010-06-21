#!/bin/bash
echo "Creating..."
# ./A_cardata2dirs.sh car_data
[ -s car_data_new ] && ./A_cardata2dirs.sh car_data_new && cat car_data car_data_new > tmp && mv tmp car_data && rm car_data_new
echo "Decoding..."
./B_decode_cars.sh
echo "Solving..."
./C_solve_cars.sh
#echo "Encoding..."
#./D_encode_fuel.sh
#echo "Testing..."
#./E_test_fuel.sh
#echo "Uploading..."
#./F_upload_fuel.sh
