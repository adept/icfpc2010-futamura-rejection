module Types where

data Side = L | R | X deriving (Eq,Ord,Show,Read)

type Slot = (Int,Side) -- gate N, side Left/Right

type Wiring = [(Slot,Slot)] -- wiring for a circuit

external :: Slot
external = (0,X)

-- Cars
data Car = Car Int [Chamber] deriving Show -- Int is ID
data Chamber = Chamber Pipe Bool Pipe deriving Show -- Bool is Main/Auxillary
type Pipe = [Int]

type Fuel = [[[Int]]]
