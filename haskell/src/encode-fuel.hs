import Types

import Encoding

key = "11021210112101221"

main = do
  raw <- getContents
  let fuel = read raw :: Fuel
  putStrLn (key ++ printFuel fuel)