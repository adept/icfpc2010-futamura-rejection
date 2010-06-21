import Control.Monad 
import Debug.Trace

inp = [0,1,2,0,2,1,0,1,2,1,0,2,0,1,2,0,2]

delay :: [Int] -> [Int]
delay trits = (0:trits)

test = and [ circuit2 == unpack "02120112100002120"
           , circuit2_5 == unpack "22022022022022022"
           , circuit3 == unpack "00100202221110100"
           , circuit4 == unpack "22120221022022120"
           , circuit7 == unpack "01210221200001210"
           , circuit8 == unpack "21202210221202210"
           , circuit9 == unpack "20002102102102102"
           ,circuit6 == unpack "22022020222220202"
           ]
       
circuit2 = outp
  where
    -- gate is  (li,ri) --> (lo,ro)
    li = inp
    outp = lo
    ri = delay ro
    (lo,ro) = unzip $ zipWith gateF li ri
    
circuit2_5 = outp
  where
    ri = inp
    outp = ro
    li = delay lo
    (lo,ro) = unzip $ zipWith gateF li ri

circuit3  = outp
  where
    li1 = inp
    outp = lo2
    ri1 = delay ro1
    (lo1,ro1) = unzip $ zipWith gateF li1 ri1
    li2 = lo1
    ri2 = delay ro2
    (lo2,ro2) = unzip $ zipWith gateF li2 ri2


circuit4 = outp
  where
    li = inp
    outp = ro
    ri = delay lo
    (lo,ro) = unzip $ zipWith gateF li ri

circuit7 = outp
  where
    ri = inp
    outp = lo
    li = delay ro
    (lo,ro) = unzip $ zipWith gateF li ri

circuit8 = outp
  where
    ri1 = inp
    outp = ro2
    li1 = delay lo1
    (lo1,ro1) = unzip $ zipWith gateF li1 ri1
    ri2 = ro1
    li2 = delay lo2
    (lo2,ro2) = unzip $ zipWith gateF li2 ri2

circuit9 = outp
  where
    ri1 = inp
    outp = lo2
    li1 = delay lo1
    (lo1,ro1) = unzip $ zipWith gateF li1 ri1
    li2 = ro1
    ri2 = delay ro2
    (lo2,ro2) = unzip $ zipWith gateF li2 ri2

circuit6 = outp
  where
    li1 = inp
    outp = ro2
    ri1 = delay ro1
    (lo1,ro1) = unzip $ zipWith gateF li1 ri1
    ri2 = lo1
    li2 = delay lo2
    (lo2,ro2) = unzip $ zipWith gateF li2 ri2


gateF 0 0 = (0,2)
gateF 0 1 = (2,2) 
gateF 0 2 = (1,2) 
gateF 1 0 = (1,2) 
gateF 1 1 = (0,0) 
gateF 1 2 = (2,1) 
gateF 2 0 = (2,2) 
gateF 2 1 = (1,1) 
gateF 2 2 = (0,0) 


brute = do
  l00 <- [0,1,2]
  r00 <- trace ("l00="++show l00) [0,1,2]
  l01 <- trace (" r00="++show r00)[0,1,2]
  r01 <- trace ("  l01="++show l01) [0,1,2]
  l02 <- [0,1,2]
  r02 <- [0,1,2]
  l10 <- [0,1,2]
  r10 <- [0,1,2]
  l11 <- [0,1,2]
  r11 <- [0,1,2]
  l12 <- [0,1,2]
  r12 <- [0,1,2]
  l20 <- [0,1,2]
  r20 <- [0,1,2]
  l21 <- [0,1,2]
  r21 <- [0,1,2]
  l22 <- [0,1,2]
  r22 <- [0,1,2]
  -- if delayed wire issues 0
  let gateF 0 0 = (l00,r00) 
      gateF 0 1 = (l01,r01) 
      gateF 0 2 = (l02,r02) 
      gateF 1 0 = (l10,r10) 
      gateF 1 1 = (l11,r11) 
      gateF 1 2 = (l12,r12) 
      gateF 2 0 = (l20,r20) 
      gateF 2 1 = (l21,r21) 
      gateF 2 2 = (l22,r22)
  
  let circuit2 = outp
        where
          -- gate is  (li,ri) --> (lo,ro)
          li = inp
          outp = lo
          ri = delay ro
          (lo,ro) = unzip $ zipWith gateF li ri
      
  let circuit2_5 = outp
        where
          ri = inp
          outp = ro
          li = delay lo
          (lo,ro) = unzip $ zipWith gateF li ri
  
  let circuit3 = outp
        where
          li1 = inp
          outp = lo2
          ri1 = delay ro1
          (lo1,ro1) = unzip $ zipWith gateF li1 ri1
          li2 = lo1
          ri2 = delay ro2
          (lo2,ro2) = unzip $ zipWith gateF li2 ri2

  guard (circuit2 == unpack "02120112100002120")
  guard (circuit2_5 == unpack "22022022022022022")
  guard (circuit3 == unpack "00100202221110100")
  return [l00,r00,l01,r01, l02,r02,l10 ,r10,l11,  r11 , l12, r12 , l20,r20 ,l21, r21 ,l22, r22 ]
  

unpack str = map (read.(:[])) str
    
main = print brute