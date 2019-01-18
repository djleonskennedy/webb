module Main where

import Network.Wai.Handler.Warp (run)
import Lib


main :: IO ()
main = do
    --putStrLn $ res Yes
    putStrLn $ "http://localhost:8080/"
    app