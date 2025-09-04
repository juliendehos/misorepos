{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Gitlab.Api where

import Data.Proxy
import Data.Text
import Miso 
import Miso.Router (prettyURI)
import Servant.API hiding (URI)
import Servant.Links hiding (URI)
import Servant.Miso.Router

import Gitlab.Repo
import Gitlab.User

type UserRoute
    = "api"
    :> "v4"
    :> "users"
    :> QueryParam' '[Required] "username" Text
    :> Get '[JSON] [User]

type RepoRoute
    = "api"
    :> "v4"
    :> "users"
    :> Capture "username" Text
    :> "projects"
    :> Get '[JSON] [Repo]

type GitlabRoutes
    =    UserRoute
    :<|> RepoRoute

uriUsers, uriRepos :: Text -> URI
uriUsers :<|> uriRepos = 
  allLinks' toMisoURI (Proxy @GitlabRoutes)

mkGitlabUrl :: URI -> MisoString
mkGitlabUrl uri = "https://gitlab.com" <> prettyURI uri

