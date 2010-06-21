import Types
import Wiring
import Control.Monad
import Data.List

delayer = read "[((0,R),(0,R)),((0,L),(0,X)),((0,X),(0,L))]" :: Wiring


w0 = delayer
w1 = read "[((0,L),(0,L)),((0,R),(1,R)),((1,R),(0,R)),((1,L),(0,X)),((0,X),(1,L))]" :: Wiring
w2 = read "[((0,L),(0,L)),((0,R),(1,R)),((1,L),(0,R)),((1,R),(0,X)),((0,X),(1,L))]" :: Wiring

main = do
  trits <- getLine
  putStrLn $ wiring2circuit $ bruteforce $ map (read.(:[])) trits

bruteforce trits = brute []
  where
    input = take (length trits + 1) (repeat 0)
    brute acc 
      | length acc == length trits = foldl1 append $ acc ++ [delayer]
      | otherwise = case find check [w0, w1, w2] of
                      Nothing -> error "Cannot encode next trit"
                      Just v -> brute (acc ++[v])
      where
        check variant = 
          let circuit = acc ++ [variant, delayer]
              len = length acc + 1
              res = eval (foldl1 append circuit) input
              in take len trits == take len res
