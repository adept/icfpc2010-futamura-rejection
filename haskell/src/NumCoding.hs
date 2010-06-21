module NumCoding (encode, decode) where

import Text.Parsec
import Control.Applicative

import Data.List

import Data.Char ( isDigit, digitToInt, intToDigit, ord, chr )
import Numeric ( showIntAtBase, readInt )

import Debug.Trace
encode 0 = "0"
encode n | n <= 3 = "1" ++ (toBaseThree (n-1) 0)
	 | otherwise = "22" ++ (encode $ mantissaLength) ++ (toBaseThree (n - basePart) (mantissaLength+2) )
  where
    smallerBases = fst (span (<=n) bases)
    basePart = last smallerBases
    mantissaLength = length smallerBases - 1
    bases = map fromBaseThree $ iterate ('1':) "11"

test_decode s = parse decode "" s

test_enc_dec n = (encode n, parse decode "" $ encode n)

-- Regression test:
-- 0: 0 : 0
-- 1: 10 : 1
-- 2: 11 : 2
-- 3: 12 : 3
-- 4: 2000 : 4
-- 5: 2001 : 5
-- 6: 2002 : 6
-- 7: 2010 : 7
-- 8: 2011 : 8
-- 9: 2012 : 9
-- 10: 210000 : 10
-- 11: 210001 : 11
-- 12: 210002 : 12
-- 13: 210010 : 13
-- 14: 210011 : 14
-- 15: 210012 : 15
-- 16: 210020 : 16
-- 17: 210021 : 17
-- 18: 210022 : 18
-- 19: 210100 : 19
-- 20: 210101 : 20
-- 21: 210102 : 21
-- 22: 210110 : 22
-- 23: 210111 : 23
-- 24: 210112 : 24
-- 25: 210120 : 25

decode =
  choice [ 0 <$ char '0'
         , ( (1+).read.(:[]) ) <$> ( char '1' *> anyChar )
         , do string "22"
              len <- (2+) <$> decode
              body <- sequence $ replicate len anyChar
              return $ fromBaseThree (replicate len '1') + (fromBaseThree body)
         ]

-- 0 = 0
-- 10 = 1
-- 11 = 2
-- 12 = 3
-- 220xx = xx + 4
-- 2210xxx = xxx + 13 -- 
-- 2211xxxx = xxxx + 40 -- 40
-- 2212xxxxx = xxxxx + 121
-- 2222000xxxxxx = xxxxxx + 364
-- 2210002 - 15
-- 22110101 - 50

toBaseThree n pad =
        let s = showIntAtBase 3 intToDigit n ""
            times = max 0 (pad - (length s))
        in (replicate times '0') ++ s

fromBaseThree :: String -> Int
fromBaseThree s = fst $ head $ readInt 3 isDigit digitToInt s

