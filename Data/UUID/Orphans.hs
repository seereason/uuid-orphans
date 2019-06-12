{-# LANGUAGE CPP, DeriveGeneric #-}
#if MIN_VERSION_safecopy(0,9,5)
{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE StandaloneDeriving #-}
#else
{-# LANGUAGE TemplateHaskell #-}
#endif

module Data.UUID.Orphans (showUUID) where

import Data.SafeCopy (SafeCopy(..))
import Data.Text as T (pack, unpack)
import Data.UUID.Types (toString, fromString)
import Data.UUID.Types.Internal (UUID(..))
import Language.Haskell.TH.Lift (Lift)
import Web.Routes.PathInfo

deriving instance Generic UUID

#if MIN_VERSION_safecopy(0,9,5)
instance SafeCopy UUID where version = 0
deriving instance Lift UUID
#else
$(deriveSafeCopy 0 'base ''UUID)
$(deriveLiftMany [''UUID])
#endif

instance PathInfo UUID where
  toPathSegments = (:[]) . T.pack . toString
  fromPathSegments = pToken (const ("UUID" :: String)) checkUUID
    where checkUUID txt = fromString (T.unpack txt)

-- | The Show instance for UUID does not return a string containing a
-- haskell expression, so if that is required use this function instead.
showUUID :: UUID -> String
showUUID uuid = "(read " ++ show (show uuid) ++ " :: UUID)"
