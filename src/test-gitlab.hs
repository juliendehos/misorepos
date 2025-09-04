{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

import Data.Text
-- import Miso (MisoString)
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Servant
import Servant.Client 

import Gitlab.Api
import Gitlab.Repo
import Gitlab.User

getUsers :: Text -> ClientM [User]
getRepos :: Text -> ClientM [Repo]
getUsers :<|> getRepos = client (Proxy @GitlabRoutes)

main :: IO ()
main = do
    
    mgr <- newManager tlsManagerSettings
    let env = mkClientEnv mgr (BaseUrl Https "gitlab.com" 443 "")

    putStrLn "\ngetUsers:"
    runClientM (getUsers "juliendehos") env >>= mapM_ (mapM_ print)

    putStrLn "\ngetRepos:"
    runClientM (getRepos "juliendehos") env >>= mapM_ (mapM_ print)

