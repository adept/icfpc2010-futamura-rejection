import Car

main = do
  car_data <- getContents
  mapM_ putStrLn $ car2solver $ parseCar car_data