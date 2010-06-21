import Car
import Types
import Data.List
import Data.Array
import System.Exit
import System.IO

numTanks (Car _ chambers) = length $ sort $ nub $ concatMap dump_chamber chambers
  where
    dump_chamber (Chamber upper _ lower) = upper ++ lower

maxSearchBound = 6
solutionVectors lo hi 1 = map (:[]) [lo..hi]
solutionVectors lo hi len = do
  first <- [lo..hi]
  rest <- solutionVectors lo hi (len-1)
  return (first:rest)
        
testCar5 = parseCar "2728, 22102200002210101010220101010221011111122111111111110220010"
testCar6 = parseCar "0, 122110000010"
testCar7 = parseCar "0, 12222000000000010"

maxSpace = 40000000.0 -- 40 mln variants
bruteforceFuel car@(Car _ chambers)  = 
  if any hasEmptyPipes chambers && numTanks car == 1
  then Just [[[2]]]
  else case filter eval variants of
         [] -> Nothing
         (v:vs) -> Just $ map ((:[]).(:[])) $ elems v
  where
    hi :: Integer
    hi = floor $ (maxSpace/(fromIntegral pipelineLength))**(1/(fromIntegral $ numTanks car))
    pipelineLength = maximum $ map (\(Chamber u _ l) -> max (length u) (length l)) chambers
    variants = map toArray $ solutionVectors 1 hi (numTanks car)
    toArray lst = listArray (0,length lst-1) lst
    eval = car2evaluator car
    hasEmptyPipes (Chamber u _ l) = null u || null l
    
main = do
  car_data <- getContents
  let car = strip $ parseCar car_data
  if nonscalar car
    then do hPutStrLn stderr "Nonlinear car!"
            exitFailure
    else case (bruteforceFuel car) of
           Nothing -> exitFailure
           Just f -> print f
