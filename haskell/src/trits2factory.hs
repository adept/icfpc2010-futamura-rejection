import Types
import Wiring

w0 = read "[((0,X),(0,L)),((0,L),(0,X)),((0,R),(1,L)),((1,L),(1,R)),((1,R),(2,L)),((2,L),(0,R)),((2,R),(2,R))]" :: Wiring
w1 = read "[((0,X),(2,L)),((0,L),(1,R)),((0,R),(2,R)),((1,L),(0,X)),((1,R),(0,L)),((2,L),(1,L)),((2,R),(0,R))]" :: Wiring
w2 = read "[((0,X),(2,L)),((0,L),(1,R)),((0,R),(2,R)),((1,L),(0,L)),((1,R),(0,X)),((2,L),(0,R)),((2,R),(1,L))]" :: Wiring

main = do
  trits <- getLine
  putStrLn $ wiring2circuit $ foldl1 append $ map toWire trits
  where
    toWire '0' = w0
    toWire '1' = w1
    toWire '2' = w2

