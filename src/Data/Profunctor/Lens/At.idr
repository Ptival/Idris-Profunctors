module Data.Profunctor.Lens.At

import Data.SortedMap
import Data.SortedSet
import Data.Profunctor
import Data.Profunctor.Lens
import Data.Profunctor.Index

%default total
%access public export

interface (Lensing p, Index p m a b) => At (p : Type -> Type -> Type) (m : Type) (a : Type) (b : Type) where
  at : a -> Lens' {p} m (Maybe b)

(Wander p, Lensing p, Ord k) => At p (SortedMap k v) k v where
  at k = lens (lookup k) (\m => maybe (delete k m) (\v => insert k v m))

(Wander p, Lensing p, Ord a) => At p (SortedSet a) a Unit where
  at x = lens get (flip update)
    where
      get xs = if contains x xs then Just () else Nothing
      update Nothing = delete x
      update (Just _) = insert x  