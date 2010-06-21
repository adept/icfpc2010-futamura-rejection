import Types
import Car
import Encoding
import Data.List
import Control.Applicative

pipes2car id flags ps = Car id chambers
	where
		chambers = chambers' flags (take 2 ps) (drop 2 ps)
		chambers' (f:fs) [p1,p2] [] = (Chamber p1 (f>0) p2):[]
		chambers' (f:fs) [p1,p2] pps = (Chamber p1 (f>0) p2):(chambers' fs (take 2 pps) (drop 2 pps))
		chambers' _ _ _ = error "Odd number of pipes."

carPermutations n car = concatMap tanksPermutations $ chambersPermutations car
	where
		chambersPermutations (Car id chambers) = map (Car id) (permutations chambers)
		tanksPermutations :: Car -> [Car]
		tanksPermutations (Car id chambers) = map (Car id) (permuteTanks chambers)
		permuteTanks :: [Chamber] -> [[Chamber]]
		permuteTanks chambers = map (replaceTunks chambers) tanksPermuted
		tanksPermuted = zip (repeat [0..n]) (permutations [0..n])
		replaceTunks chs rmap = map ( \(Chamber p1 f p2) -> (Chamber (replaceNums rmap p1) f (replaceNums rmap p2)) ) chs
		replaceNums (ks,vs) l = map (\x -> vs!!(findIndex x ks)) l
		findIndex e l = case elemIndex e l of
					Just i -> i
					Nothing -> error "Tunk number out of range."

{-
	input is like:
		112233 -- ID
		2 -- how many tanks
                [1] -- how many chambers, which are main
		[0,1,1,0] -- two lines per each chamber follows
		[1,0,1,1]
	Engine with 2 tanks and 1 chamber with 2 pipes
-}
main = do
	raw <- getContents
	let lns = lines raw
	let id = (read $ head lns) :: Int
	let n = (read $ head $ tail lns) :: Int
	let flags = (read $ head $ drop 2 lns) :: [Int]
	let pipes = (map read $ drop 3 lns) :: [[Int]]
	let cars = carPermutations (n - 1) $ pipes2car id flags pipes
	let s_car = head $ sort $ map printCar cars
	putStrLn s_car
	putStrLn $ show $ parseCar $ (show id) ++ ", " ++ s_car

