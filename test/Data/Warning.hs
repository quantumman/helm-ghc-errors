import Data.List

foo :: IO ()
foo = print "TEST"

main :: IO ()
main = do
  foo
  x <- return 20
  return ()
