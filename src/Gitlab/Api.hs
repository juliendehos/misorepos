{-# LANGUAGE DataKinds #-}
-- {-# LANGUAGE OverloadedStrings #-}

module Gitlab.Api where

-- import Data.Text
-- import Data.Proxy
import Miso 
-- import Miso.Router (prettyURI)
import Servant.API -- hiding (URI)
-- import Servant.Links hiding (URI)
-- import Servant.Miso.Router
-- import Servant.Miso.Client

import Gitlab.Repo
import Gitlab.User

type UserRoute
    = "https://gitlab.com"
    :> "api"
    :> "v4"
    :> "users"
    -- TODO
    -- :> QueryParam "username" MisoString
    -- :> QueryParam' '[Required] "username" MisoString
    :> Get '[JSON] [User]

type RepoRoute
    = "https://gitlab.com"
    :> "api"
    :> "v4"
    :> "users"
    -- TODO
    -- :> Capture "username" MisoString
    :> "projects"
    :> Get '[JSON] [Repo]

type GitlabRoutes
    =    UserRoute
    :<|> RepoRoute

