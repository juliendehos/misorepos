{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Gitlab.Repo where

import Data.Aeson
import GHC.Generics
import Miso

data Repo = Repo
    { id                :: Int
    , name              :: MisoString
    , description       :: Maybe MisoString
    , web_url           :: MisoString
    , last_activity_at  :: MisoString
    } deriving (Eq, Generic, Show)

instance FromJSON Repo

