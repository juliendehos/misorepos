{-# LANGUAGE DataKinds #-}

module Gitlab.Api where

import Miso 
import Servant.API

import Gitlab.Repo
import Gitlab.User

type UserRoute
  = "api"
  :> "v4"
  :> "users"
  :> QueryParam "username" MisoString
  :> Get '[JSON] [User]

type RepoRoute
  = "api"
  :> "v4"
  :> "users"
  :> Capture "username" MisoString
  :> "projects"
  :> Get '[JSON] [Repo]

type GitlabRoutes
  =    UserRoute
  :<|> RepoRoute

