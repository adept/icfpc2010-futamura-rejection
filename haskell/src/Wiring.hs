module Wiring (numGates, wiring2circuit, append, eval) where

import Types
import Data.Maybe
import Data.List

numGates wiring = maximum $ map (fst.fst) wiring ++ map (fst.snd) wiring

test1 :: Wiring
test1 = 
  read "[((0,X),(1,L)),((0,L),(2,R)),((0,R),(0,X)),((1,L),(2,L)),((1,R),(0,R)),((2,L),(1,R)),((2,R),(3,L)),((3,L),(0,L)),((3,R),(3,R))]"

wiring2circuit :: Wiring -> String
wiring2circuit wiring = connect wiring
  where
    connect :: Wiring -> String
    connect wires =
      concat [ makeInput, ":"
             , intercalate "," [ makeGate n | n <- [0..numGates wiring] ]
             , ":", makeOutput
             ]
        where
          rev_wires = map swap wires
          makeInput = 
            case (lookup externalGate rev_wires) of
              Just (0,X) -> error "Short-circuting input to output is not supported"
              Just x -> showSlot x
          makeOutput = 
            case (lookup (0,X) wires) of
              Just (0,X) -> error "Short-circuting input to output is not supported"
              Just x -> showSlot x
          makeGate n = 
            let li = fromMaybe (error $ "Cannot find left input for " ++ show n) $ lookup (n,L) wires
                ri = fromMaybe (error $ "Cannot find right input for " ++ show n) $ lookup (n,R) wires
                lo = fromMaybe (error $ "Cannot find left output for " ++ show n) $ lookup (n,L) $ rev_wires
                ro = fromMaybe (error $ "Cannot find right output for " ++ show n) $ lookup (n,R) $ rev_wires              
                in concat [ showSlot li, showSlot ri, "0#", showSlot lo, showSlot ro ]
          showSlot (0,X) = "X"
          showSlot (g,side) = show g ++ show side
          swap (a,b) = (b,a)

-- Output of the _next_ is connected to the input of _prev_
append :: Wiring -> Wiring -> Wiring
append prev next = connected_prev ++ connected_next
  where 
    max_prev_node = numGates prev
    
    next' = map (renumber (max_prev_node+1)) next
    
    renumber inc (to,from) = ( increase to, increase from )
      where increase (n,side) | externalGate == (n,side) = externalGate
                              | otherwise = (n + inc, side)
            
    next_output_node = snd $ head $ filter ((==externalGate).fst) next'

    connected_prev = [ (to, from') | (to,from) <- prev, let from' = if from == externalGate then next_output_node else from ]
    connected_next = filter ((/=externalGate).fst) next' -- each wire will be mentioned only once

eval :: [(Slot, Slot)] -> [Int] -> [Int] -- wires are a list of (to slot, from slot)
eval wires inp = 
  case (lookup externalGate wires) of
    Just (0,X) -> error "should not happen: external source -> external output"
    finalNode -> take (length inp) $ maxBound `connect` finalNode 
                 -- external gate input is assumed to be a fictitious node 
                 -- with maximum possible ID
  where
    outputs :: [ (Int,([Int],[Int])) ] -- left and right outputs of gate 'n'
    outputs = [ (n, evalGate n) | n <- [0..numGates wires] ]
        
    evalGate n = 
      let li = n `connect` (lookup (n,L) wires)
          ri = n `connect` (lookup (n,R) wires)
      in gate li ri
         
    connect _ (Just (0,X)) = inp -- connection to external gate output in an input list
    connect n (Just (source,side)) = 
      let getSide = if side == L then fst else snd
          maybeDelay = if source >= n then delay else id
      in maybeDelay $ getSide $ fromJust (lookup source outputs)
    connect n Nothing = error $ "Requested connection from nonexisting node to " ++ show n

delay :: [Int] -> [Int]
delay trits = (0:trits)

gate li ri = (lo,ro)
  where
    (lo,ro) = unzip $ zipWith gateF li ri

gateF 0 0 = (0,2)
gateF 0 1 = (2,2)
gateF 0 2 = (1,2)
gateF 1 0 = (1,2)
gateF 1 1 = (0,0)
gateF 1 2 = (2,1)
gateF 2 0 = (2,2)
gateF 2 1 = (1,1)
gateF 2 2 = (0,0)
