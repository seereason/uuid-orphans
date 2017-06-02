{-# LANGUAGE CPP, TemplateHaskell #-}
module Data.UUID.Orphans (showUUID) where

import Data.SafeCopy (base, deriveSafeCopy)
import Data.Text as T (pack, unpack)
import Data.UUID.Types (UUID, toString, fromString)
import Language.Haskell.TH.Lift (deriveLiftMany)
import Web.Routes.PathInfo

$(deriveSafeCopy 0 'base ''UUID)

instance PathInfo UUID where
  toPathSegments = (:[]) . T.pack . toString
  fromPathSegments = pToken (const ("UUID" :: String)) checkUUID
    where checkUUID txt = fromString (T.unpack txt)

$(deriveLiftMany [
   ''UUID
  ])

-- | The Show instance for UUID does not return a string containing a
-- haskell expression, so if that is required use this function instead.
showUUID :: UUID -> String
showUUID uuid = "(read " ++ show (show uuid) ++ " :: UUID)"
