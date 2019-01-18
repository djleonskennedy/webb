{-# LANGUAGE DeriveGeneric #-}
module Lib
    ( app
    ) where

import Jose.Jws
import Jose.Jwa
import Data.Monoid ((<>))
import GHC.Generics
import Data.Aeson.Types
import Network.HTTP.Types.Status
import Data.Text.Lazy (Text)
import Web.Scotty.Trans (liftAndCatchIO, body, json, scottyT, 
                        ScottyT, ActionT, get, post, html, header, 
                        jsonData, status)

type ScottyM = ScottyT Text IO
type ActionM = ActionT Text IO

--newtype Label = Label String 
--newtype Price = Price Int

--data Component = Component Label Price

--label :: Component -> Label 
--label (Component l _) = l

data User = User
  { username :: String
  , password :: String
  }  deriving (Generic, Show, Eq)

instance FromJSON User

response200 :: (ToJSON a) => a -> ActionM ()
response200 a = do
  status status200
  json a

response401 :: (ToJSON a) => a -> ActionM ()
response401 a = do
  status status401
  json a



data LoginResp = LoginResp 
  { stat :: String
  , token :: String
  } deriving (Generic, Show)

instance ToJSON LoginResp

data Token = Token
  { sub :: String
  , name :: String
  }


user = User "user" "pass"
token = Token "1" "user"

checkUser :: User -> ActionM ()
checkUser u = if u == user 
                then
                  response200 $ LoginResp "Ok" "DD"
                else 
                  response401 $ LoginResp "Error" ""

app :: IO ()
app = scottyT 3000 id $ do
  post "/login" $ do
    user <- jsonData :: ActionM User
    liftAndCatchIO $ print user
    checkUser user
  get "/secret" $ do
    token <- header "token" 
    html "secret"