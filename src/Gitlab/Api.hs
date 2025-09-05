{-# LANGUAGE DataKinds #-}

module Gitlab.Api where

import Miso 
import Servant.API

import Gitlab.Repo
import Gitlab.User

type UserRoute
  = "https://gitlab.com"
  :> "api"
  :> "v4"
  :> "users"
  :> QueryParam "username" MisoString
  -- :> QueryParam' '[Required] "username" MisoString     -- TODO
  :> Get '[JSON] [User]

type RepoRoute
  = "https://gitlab.com"
  :> "api"
  :> "v4"
  :> "users"
  :> Capture "username" MisoString
  :> "projects"
  :> Get '[JSON] [Repo]

type GitlabRoutes
  =    UserRoute
  :<|> RepoRoute

