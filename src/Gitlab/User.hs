{-# LANGUAGE DeriveGeneric #-}

module Gitlab.User where

import Data.Aeson
import GHC.Generics
import Miso

data User = User
    { id            :: Int
    , name          :: MisoString
    , username      :: MisoString
    , avatar_url    :: MisoString
    } deriving (Eq, Generic, Show)

instance FromJSON User

