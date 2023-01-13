{-# LANGUAGE InstanceSigs #-}

module Lib
  ( usesHcsUnit,
    usesHcsBool,
    usesNoHcsUnit,
    usesNoHcsBool,
  )
where

import GHC.Stack (HasCallStack)

-- 1. HCS class

class HCS a where
  hcs :: HasCallStack => a -> ()

-- 1.1 HCS class + HCS instance
instance HCS () where
  hcs :: HasCallStack => () -> ()
  hcs _ = error "hcs ()"

-- 1.1 HCS class + No HCS instance
instance HCS Bool where
  hcs :: Bool -> ()
  hcs _ = error "hcs bool"

-- 2. No HCS class

class NoHCS a where
  noHcs :: a -> ()

-- 2.1. No HCS class + HCS instance
instance NoHCS () where
  noHcs :: HasCallStack => () -> ()
  noHcs _ = error "nohcs ()"

-- 2.2. No HCS class + No HCS instance
instance NoHCS Bool where
  noHcs :: Bool -> ()
  noHcs _ = error "nohcs bool"

usesHcs :: (HasCallStack, HCS a) => a -> ()
usesHcs = hcs

usesNoHcs :: (HasCallStack, NoHCS a) => a -> ()
usesNoHcs = noHcs

-- >>> print usesHcsUnit
--
-- hcs-class: hcs ()
-- CallStack (from HasCallStack):
--   error, called at src/Lib.hs:15:11 in hcs-class-0.1-inplace:Lib
--   a type signature in an instance, called at src/Lib.hs:14:10 in hcs-class-0.1-inplace:Lib
--   hcs, called at src/Lib.hs:36:11 in hcs-class-0.1-inplace:Lib
--   usesHcs, called at src/Lib.hs:42:15 in hcs-class-0.1-inplace:Lib
--   usesHcsUnit, called at app/Main.hs:12:14 in main:Main

usesHcsUnit :: HasCallStack => ()
usesHcsUnit = usesHcs ()

-- >>> print usesHcsBool
--
-- hcs-class: hcs bool
-- CallStack (from HasCallStack):
--   error, called at src/Lib.hs:20:11 in hcs-class-0.1-inplace:Lib

usesHcsBool :: HasCallStack => ()
usesHcsBool = usesHcs True

-- >>> print usesNoHcsUnit
--
-- hcs-class: nohcs ()
-- CallStack (from HasCallStack):
--   error, called at src/Lib.hs:29:13 in hcs-class-0.1-inplace:Lib
--   a type signature in an instance, called at src/Lib.hs:28:12 in hcs-class-0.1-inplace:Lib

usesNoHcsUnit :: HasCallStack => ()
usesNoHcsUnit = usesNoHcs ()

-- >>> print usesNoHcsBool
--
-- hcs-class: nohcs bool
-- CallStack (from HasCallStack):
--   error, called at src/Lib.hs:33:13 in hcs-class-0.1-inplace:Lib

usesNoHcsBool :: HasCallStack => ()
usesNoHcsBool = usesNoHcs True
