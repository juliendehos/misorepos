{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module App.Component (mkComponent) where

import Data.Maybe (fromMaybe)
import Data.Proxy
import Miso
import Miso.Lens
import Miso.Html.Element as H
import Miso.Html.Event as E
import Miso.Html.Property as P
import Servant.API -- hiding (URI)
import Servant.Miso.Client

import App.Model
import Gitlab.Api
import Gitlab.Repo as Repo
import Gitlab.User as User

-------------------------------------------------------------------------------
-- component
-------------------------------------------------------------------------------

type MyComponent = App Model Action

mkComponent ::MyComponent
mkComponent = component emptyModel updateModel viewModel

-------------------------------------------------------------------------------
-- routing
-------------------------------------------------------------------------------

-- gitlabUsers :: MisoString -> ([User] -> Action) -> (MisoString -> Action) -> Transition Model Action
-- gitlabRepos :: MisoString -> ([Repo] -> Action) -> (MisoString -> Action) -> Transition Model Action
gitlabUsers :<|> gitlabRepos = toClient (Proxy @MyComponent) (Proxy @GitlabRoutes)

-------------------------------------------------------------------------------
-- actions
-------------------------------------------------------------------------------

data Action
  = ActionError MisoString
  | ActionInputUsers MisoString
  | ActionAskGitlab
  | ActionSetGitlabUsers [User]
  | ActionSetGitlabRepos [Repo]
  deriving (Show, Eq)

-------------------------------------------------------------------------------
-- update
-------------------------------------------------------------------------------

updateModel :: Action -> Transition Model Action

updateModel (ActionError str) = do
  modelError .= str
  modelUsers .= []
  modelRepos .= []

updateModel (ActionInputUsers str) =
  modelInputUsers .= str

updateModel ActionAskGitlab = do
  modelError .= ""
  inputUsers <- use modelInputUsers

  -- TODO
  gitlabUsers ActionSetGitlabUsers ActionError
  -- gitlabUsers inputUsers ActionSetGitlabUsers ActionError
  pure ()


{-
  let str = fromMisoString inputUsers
      headers = [("Content-Type", "application/json")]
  io_ $ consoleLog $ mkGitlabUrl $ uriUsers str
  getJSON (mkGitlabUrl $ uriUsers str) headers ActionSetGitlabUsers ActionError
  getJSON (mkGitlabUrl $ uriRepos str) headers ActionSetGitlabRepos ActionError
-}

updateModel (ActionSetGitlabUsers users) =
  modelUsers .= users

updateModel (ActionSetGitlabRepos repos) =
  modelRepos .= repos

-------------------------------------------------------------------------------
-- view
-------------------------------------------------------------------------------

viewModel :: Model -> View Model Action
viewModel Model{..} = 
  div_ []
    ([ h2_ [] [ "search user" ]
    , input_ [ onInput ActionInputUsers, value_ _modelInputUsers ]
    , button_ [ onClick ActionAskGitlab ] [ "search" ]
    , p_ [] [ text _modelError ]
    ]
    <> fmtUsers _modelUsers
    <> fmtRepos _modelRepos
    )

fmtUsers :: [User] -> [View model action]
fmtUsers [] = []
fmtUsers users =
  [ h2_ [] [ "Users" ]
  , ul_ [] $ map fmtUser users
  ]
  where
    fmtUser user = 
      li_ []
        [ text (User.name user <> " (" <> username user <> ")")
        , p_ [] [ img_ [ src_ (avatar_url user) ] ]
        ] 

fmtRepos :: [Repo] -> [View model action]
fmtRepos [] = []
fmtRepos repos =
  [ h2_ [] [ "Repos" ]
  , ul_ [] $ map fmtRepo repos
  ]
  where
    fmtRepo repo = 
      li_ []
        [ a_ [ href_ (web_url repo) ] [ text (Repo.name repo) ]
        , p_ [] [ text ("description: " <> fromMaybe "" (description repo)) ]
        , p_ [] [ text ("last update: " <> last_activity_at repo) ]
        ] 

