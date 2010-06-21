import Car

main = do
  car_data <- getContents
  mapM_ print $ parseCars car_data