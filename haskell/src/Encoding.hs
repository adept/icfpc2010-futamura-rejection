module Encoding ( listOf
                , num
                , printListOf
                , printNum
		, fuel
		, printFuel) where

import NumCoding as Num
import Text.Parsec
import Control.Applicative hiding ((<|>))

listOf p =
  choice [ [] <$ char '0'
         , (:[]) <$> ( char '1' *> p )
         , do string "22"
              len <- num
              sequence $ replicate (len+2) p
         ]

fuel = listOf $ listOf $ listOf num

num = Num.decode

--------------

printListOf p [] = "0"
printListOf p [x] = "1" ++ p x
printListOf p xs = 
  concat [ "22"
         , printNum (length xs - 2)
         , concatMap p xs
         ]

printFuel = printListOf printMatrix
printMatrix = printListOf printRow
printRow = printListOf printNum

printNum = Num.encode
