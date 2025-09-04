{-# LANGUAGE OverloadedStrings #-}

module App.Model where

import Miso
import Miso.Lens
import Miso.Lens.TH

import Gitlab.Repo
import Gitlab.User

data Model = Model
  { _modelError :: MisoString
  , _modelInputUsers :: MisoString
  , _modelUsers :: [User]
  , _modelRepos :: [Repo]
  } deriving (Eq)

makeLenses ''Model

emptyModel :: Model
emptyModel = Model "" "" [] []

