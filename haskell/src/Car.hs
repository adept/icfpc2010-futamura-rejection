module Car (parseCar, parseCars, printCar, car2solver, car2evaluator, car2debugEvaluator, nonscalar, strip) where

import Text.Parsec
import Control.Applicative hiding ((<|>), many, optional)
import Types
import Encoding
import Data.List
import Data.Maybe
import Data.Array
import Debug.Trace
import Text.Printf

-- Parsing

parseCars = doParse cars
parseCar = doParse car

doParse p str = 
  case parse p "car data" str of
    Left err ->  error $ show err
    Right car -> car

cars = many (car <* optional space)
car = Car <$> (read <$> many1 (oneOf "0123456789")) <*> ( char ',' *> space *> listOf chamber)

chamber = Chamber <$> pipe <*> chamberType <*> pipe

pipe = listOf num 

chamberType =
  choice [ True <$ char '0'
         , False <$ string "10"
         ]

car2solver (Car _ chambers) = map chamber2equation chambers
  where
    tanks = sort $ nub $ concatMap dump_chamber chambers
    dump_chamber (Chamber upper _ lower) = upper ++ lower

    tank_mapping = zip tanks ['A'..]
    chamber2equation (Chamber upper ctype lower) = 
      intercalate " " [ map_tanks upper, "-", map_tanks lower, if ctype then ">" else ">=", "0" ]
      
    map_tanks ids = map (\i -> fromJust $ lookup i tank_mapping) ids
    
-- Pretty printing

printCar (Car _ chambers) = printListOf printChamber chambers
printChamber (Chamber upper_pipe ctype lower_pipe) =
  concat [ printListOf printNum upper_pipe
         , printChamberType ctype
         , printListOf printNum lower_pipe
         ]
  
printChamberType True = "0"
printChamberType False = "10"

-- Conver car to a function that accepts fuel and returns Bool 
-- describing whether or not the fuel fits

car2evaluator :: Car -> Array Int Integer -> Bool
car2evaluator = car2evaluator' False

car2debugEvaluator :: Car -> Array Int Integer -> Bool
car2debugEvaluator = car2evaluator' True

car2evaluator' debug (Car _ chambers) = (\values -> and (map (evalchamber values) chambers))
  where
    tanks = sort $ nub $ concatMap dump_chamber chambers
    dump_chamber (Chamber upper _ lower) = upper ++ lower

    evalchamber values (Chamber upper ctype lower) = 
      let upper_val = ( product $ map (values!) upper ) :: Integer
          lower_val = ( product $ map (values!) lower ) :: Integer
          res = if ctype 
                then upper_val > lower_val 
                else upper_val >= lower_val
      in if debug
         then trace (printf "Upper: %d, lower: %d" upper_val lower_val) res
         else res

-- Checks that the car could not be fuelled by the fuel with scalar components
-- If some chamber has equal segments in upper and lower pipes (in any order),
-- then only matrix fuel will fit.

nonscalar (Car _ chambers) = or $ map check_chamber chambers
  where
    check_chamber (Chamber upper ctype lower) = ctype && sort upper == sort lower

-- Remove matching tanks from chamber pipes to simplify brute of scalar fuels
strip (Car i chambers) = Car i (map strip_chamber chambers)
  where
    strip_chamber (Chamber upp ctype low) = (Chamber u1 ctype l1)
      where
        (u1,l1) = strip_prefix (sort upp) (sort low)
    strip_prefix [] [] = ([],[])
    strip_prefix [] y = ([],y)
    strip_prefix x [] = (x,[])
    strip_prefix (u:us) (l:ls) | u == l = strip_prefix us ls
                               | otherwise = (u:us, l:ls)

testCar1 = "0, 122000010"
testCar2 = "0, 122110000010"
testCar3 = "0, 12222000000000010"
testCar4 = "2728, 22102200002210101010220101010221011111122111111111110220010"

