import Car
import Types
import Data.List
import Data.Array
import Control.Applicative

main = do
  car <- parseCar <$> readFile "car.def"
  fuel <- read <$> readFile "car.fuel_formula"
  print $ car2debugEvaluator car $ toArray fuel
    where
      toArray lst = listArray (0,length lst-1) $ map (\[[x]] -> x) lst
