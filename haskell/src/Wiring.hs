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
            case (lookup external rev_wires) of
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
      where increase (n,side) | external == (n,side) = external
                              | otherwise = (n + inc, side)
            
    -- prev_input_node = fst $ head $ filter ((==external).snd) prev
    next_output_node = snd $ head $ filter ((==external).fst) next'

    connected_prev = [ (to, from') | (to,from) <- prev, let from' = if from == external then next_output_node else from ]
    connected_next = filter ((/=external).fst) next' -- each wire will be mentioned only once


eval wires inp = 
  case (lookup external wires) of
    Just (0,X) -> error "should not happen: external source -> external output"
    Just (source,side) -> take (length inp) $ (if side == L then fst else snd) (fromJust (lookup source c))
  where
        c :: [ (Int,([Int],[Int])) ]
        c = [ (n,makeGate n) | n <- [0..numGates wires] ]
        makeGate n = 
          let li = case (lookup (n,L) wires) of
                     Just (0,X) -> inp
                     Just (source,side) -> extract n side source -- (fromJust (lookup source c),side)
              ri = case (lookup (n,R) wires) of
                     Just (0,X) -> inp
                     Just (source,side) -> extract n side source -- (fromJust (lookup source c),side)
              in gate li ri
        extract n side source = 
          let ef = if side == L then fst else snd
              df = if source >= n then delay else id
              in df $ ef $ fromJust (lookup source c)

delay :: [Int] -> [Int]
delay trits = (0:trits)

gate li ri = (lo,ro)
  where
    (lo,ro) = unzip $ zipWith gateF li ri

gateF 0 0 = (0,2) -- via 2 and 7, step 0
gateF 0 1 = (2,2) -- via 2.5, step 1
gateF 0 2 = (1,2) -- via 6, step 1
gateF 1 0 = (1,2) -- via 4, step 1
gateF 1 1 = (0,0) -- via 3, step 2
gateF 1 2 = (2,1) -- via 2, step 1
gateF 2 0 = (2,2) -- via 9, step 0
gateF 2 1 = (1,1) -- via 7, step 1
gateF 2 2 = (0,0) -- via 3(akuklev)
