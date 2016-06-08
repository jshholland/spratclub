module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
  setTitle "spratclub"
  $(widgetFile "homepage")
