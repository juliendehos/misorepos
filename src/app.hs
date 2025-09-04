{-# LANGUAGE OverloadedStrings #-}

import Miso

import App.Component

main :: IO ()
main = run $ startComponent mkComponent

#ifdef WASM
foreign export javascript "hs_start" main :: IO ()
#endif

