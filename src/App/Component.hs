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
import Servant.API
import Servant.Miso.Client

import App.Model
import Gitlab.Api
import Gitlab.Repo as Repo
import Gitlab.User as User

import Language.Javascript.JSaddle (fromJSValUnchecked)   -- TODO

-------------------------------------------------------------------------------
-- component
-------------------------------------------------------------------------------

type MyComponent = App Model Action

mkComponent ::MyComponent
mkComponent = component emptyModel updateModel viewModel

-------------------------------------------------------------------------------
-- routing
-------------------------------------------------------------------------------

baseUrl :: MisoString
baseUrl = "https://gitlab.com"

gitlabUsers :: Maybe MisoString -> (Response [User] -> Action) -> (Response JSVal -> Action) -> Transition Model Action
gitlabRepos :: MisoString -> (Response [Repo] -> Action) -> (Response JSVal -> Action) -> Transition Model Action
gitlabUsers :<|> gitlabRepos = toClient baseUrl (Proxy @MyComponent) (Proxy @GitlabRoutes)

-------------------------------------------------------------------------------
-- actions
-------------------------------------------------------------------------------

data Action
  = ActionError MisoString
  | ActionAskError (Response JSVal)
  | ActionInputUsers MisoString
  | ActionAskGitlab
  | ActionSetGitlabUsers (Response [User])
  | ActionSetGitlabRepos (Response [Repo])

-------------------------------------------------------------------------------
-- update
-------------------------------------------------------------------------------

updateModel :: Action -> Transition Model Action

updateModel (ActionAskError err) = do
  let msg = ms $ show $ errorMessage err
  io (ActionError . (\e -> msg <> " - " <> e) <$> fromJSValUnchecked (body err))

updateModel (ActionError str) = do
  modelError .= str
  modelUsers .= []
  modelRepos .= []

updateModel (ActionInputUsers str) =
  modelInputUsers .= str

updateModel ActionAskGitlab = do
  modelError .= ""
  inputUsers <- use modelInputUsers
  gitlabUsers (Just inputUsers) ActionSetGitlabUsers ActionAskError
  gitlabRepos inputUsers ActionSetGitlabRepos ActionAskError

updateModel (ActionSetGitlabUsers respUsers) =
  modelUsers .= body respUsers

updateModel (ActionSetGitlabRepos respRepos) =
  modelRepos .= body respRepos

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

