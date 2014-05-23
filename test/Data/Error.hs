import Data.List

test :: IO a
test = do
  x <- func
  return x

foo :: Int
