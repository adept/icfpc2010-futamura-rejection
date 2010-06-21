import Control.Monad 
import Debug.Trace
import Data.List
import Data.Maybe
import System.Environment
import Types
import Wiring

inp = [0, 1, 2, 0, 2, 1, 0, 1, 2, 1, 0, 2, 0, 1, 2, 0, 2]
key = [1, 1, 0, 2, 1, 2, 1, 0, 1, 1, 2, 1, 0, 1, 2, 2, 1]

-- Return all slot names for a circuit on `maxgates' gates
allSlots maxgates = do
  gateN <- [0..maxgates-1]
  side <- [L,R]
  return (gateN,side)

-- Produce all possible wirings between `maxgates' gates that
-- leave exactly one input and one output
allWireCombinations maxgates = do
  let sinks = (external:slots)
  faucets <- permutations (external:slots)
  guard (head faucets /= external)
  return $ zip sinks faucets
  where
    slots = allSlots maxgates

every n lst = unfoldr (chunk n) lst
  where
    chunk n [] = Nothing
    chunk n lst = Just (head lst, drop n lst)

allCircuits block offset maxgates = do
  wires <- every block $ drop offset $ allWireCombinations maxgates
  return $ (wires, eval wires inp)

-- Run all possible wirings through the evaluator, until the one that produces the key
-- is found 
runAll block offset size = [ w | (w,res) <- allCircuits block offset size, res ==key]

main = do
  [block,offset] <- getArgs
  forM [1..3] $ \size ->
    do putStrLn $ "Processing " ++ show size
       mapM_ (putStrLn.wiring2circuit) $ runAll (read block) (read offset) size
