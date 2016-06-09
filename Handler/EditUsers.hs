module Handler.EditUsers where

import Import
import Yesod.Form.Bootstrap3

form :: Form User
form = renderBootstrap3 BootstrapInlineForm $ User
  <$> areq textField (bfs ("Name" :: Text)) Nothing
  <*> pure Nothing
  <*> pure False
  <*> pure Nothing
  <*  bootstrapSubmit ("Add" :: BootstrapSubmit Text)

getEditUsersR :: Handler Html
getEditUsersR =  do
  users <- runDB $ selectList [] []
  (formWidget, formEnctype) <- generateFormPost form
  defaultLayout $ do
    setTitle "User admin"
    $(widgetFile "editusers")

postEditUsersR :: Handler Html
postEditUsersR = do
  users <- runDB $ selectList [] []
  ((result, formWidget), formEnctype) <- runFormPost form
  case result of
    FormSuccess user -> do
      _ <- runDB $ insert user
      setMessage . toHtml $ "Successfully added user: " <> userName user
      redirect EditUsersR
    _ -> do
      setMessage "Error submitting form, try again"
      defaultLayout $ do
        setTitle "User admin"
        $(widgetFile "editusers")
