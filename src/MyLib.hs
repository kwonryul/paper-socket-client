{-# LANGUAGE ForeignFunctionInterface #-}

module MyLib (someFunc) where

import Foreign.Ptr
import Control.Concurrent
import System.IO

foreign import ccall "hello" muki :: FunPtr (Int -> IO ()) -> IO ()
foreign import ccall "wrapper" huki :: (Int -> IO ()) -> IO (FunPtr (Int -> IO ()))
foreign import ccall "ctart" kiki ::  IO ()
foreign import ccall "python_init" ini :: IO ()
foreign import ccall "python_finalize" finn :: IO ()

someFunc :: IO ()
someFunc = do
    haskfun' <- huki haskfun
    muki haskfun'
    ini
    _ <- forkIO kiki
    _ <- forkIO kiki
    _ <- forkIO kiki
    _ <- forkIO kiki
    _ <- forkIO kiki
    threadDelay 10000000
    finn

haskfun :: Int -> IO ()
haskfun k = do
    print k
    print $ foldl (\x y -> x + y) 0 [1..800000000]