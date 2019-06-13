{-# LANGUAGE CPP, DeriveGeneric, DeriveLift #-}
#if MIN_VERSION_safecopy(0,9,5)
{-# LANGUAGE StandaloneDeriving #-}
#else
{-# LANGUAGE TemplateHaskell #-}
#endif

module Data.UUID.Orphans (showUUID) where

import Data.SafeCopy -- (base, contain, deriveSafeCopy, SafeCopy(..))
import Data.Text as T (pack, unpack)
import Data.UUID.Types (toString, fromString)
import Data.UUID.Types.Internal (UUID(..))
import Language.Haskell.TH.Lift (Lift)
import Web.Routes.PathInfo

deriving instance Generic UUID

#if MIN_VERSION_safecopy(0,9,5)
instance SafeCopy UUID where version = 0
#else
$(deriveSafeCopy 0 'base ''UUID)
#endif

#if 0
-- Splices
instance SafeCopy UUID where
      putCopy (UUID a1 a2 a3 a4)
        = contain
            (do safePut_Word32 <- getSafePut
                safePut_Word32 a1
                safePut_Word32 a2
                safePut_Word32 a3
                safePut_Word32 a4
                return ())
      getCopy
        = contain
            ((label "Data.UUID.Types.Internal.UUID:")
               (do safeGet_Word32 <- getSafeGet
                   ((((return UUID <*> safeGet_Word32) <*> safeGet_Word32)
                       <*> safeGet_Word32)
                      <*> safeGet_Word32)))
      version = 0
      kind = base
      errorTypeName _ = "Data.UUID.Types.Internal.UUID"
#endif

deriving instance Lift UUID

instance PathInfo UUID where
  toPathSegments = (:[]) . T.pack . toString
  fromPathSegments = pToken (const ("UUID" :: String)) checkUUID
    where checkUUID txt = fromString (T.unpack txt)

-- | The Show instance for UUID does not return a string containing a
-- haskell expression, so if that is required use this function instead.
showUUID :: UUID -> String
showUUID uuid = "(read " ++ show (show uuid) ++ " :: UUID)"
