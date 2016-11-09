% Intro to Haskell, day 5
% G Bordyugov
% Nov 2016


Today
=====

0. Folds, folds, folds
1. Monoids

~~~{.haskell}
import Prelude hiding (foldr, foldl)
~~~

Right fold
==========
Definition:

~~~{.haskell}
foldr :: (b -> a -> a) -> a -> [b] -> a
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)
~~~

An example expansion:

~~~{.haskell .ignore}
foldr (+) 0 [1, 2, 3, 4, 5] =>
1 + (foldr (+) 0 [2, 3, 4, 5]) =>
1 + (2 + (foldr (+) 0 [3, 4, 5])) =>
1 + (2 + (3 + (foldr (+) 0 [4, 5]))) =>
... =>
1 + (2 + (3 + (4 + (5 + 0))))
~~~

Left fold
=========
Definition:

~~~{.haskell}
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f z []     = z
foldl f z (x:xs) = foldl f (f z x) xs
~~~

An example expansion:

~~~{.haskell .ignore}
foldl (+) 0 [1, 2, 3, 4, 5] =>
foldl (+) (0 + 1) [2, 3, 4, 5] =>
foldl (+) ((0 + 1) + 2) [3, 4, 5] =>
foldl (+) (((0 + 1) + 2) + 3) [4, 5] =>
... =>
((((0 + 1) + 2) + 3) + 4) + 5
~~~

`foldl` through `foldr`
=======================
~~~{.haskell .ignore}
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f z xs = smth z

smth :: a -> a
smth = foldr f' z' xs'
~~~

__Given__: `f, z, xs`, __unknown__: `f', z', xs'`

Type signature of `foldr`:

~~~{.haskell .ignore}
foldr :: (u -> v -> v) -> v -> [u] -> v

  =>     u = b   (xs' == xs)
         v = a -> a
~~~


`foldl` through `foldr`
=======================
Above type inference results in

~~~{.haskell .ignore}
f' :: u -> v -> v = b -> (a -> a) -> (a -> a)
~~~

The only possible definition of `f'` is hence:

~~~{.haskell .ignore}
f' x g = \y -> g (f y x)
  where x :: b
        g :: a -> a
        y :: a
        f :: a -> b -> a -- argument of foldl
~~~

Summarizing:

~~~{.haskell}
foldl' f z xs = foldr f' id xs z where
  f' x g = \y -> g (f y x)
~~~


Monoids
=======
A typeclass for _composable_ things

~~~{.haskell .ignore}
class Monoid m where
  mempty :: m
  mappend :: m -> m -> m
  mconcat = foldr mappend mempty

x <> y = mappend x y
~~~

Monoid = semigroup + zero element

__Monoid Laws__:

~~~{.haskell .ignore}
x <> mempty = x
mempty <> x = x
(x <> y) <> z = x <> (y <> z)
~~~

Monoid trivial examples
=======================

~~~{.haskell .ignore}
instance Monoid Int where
  mempty = 0
  mappend = (+)

instance Monoid Int where
  mempty = 1
  mappend = (*)

instance Monoid [a] where
  mempty = []
  mappend = (++)

instance Monoid (a -> a) where
  mempty = id
  mappend = (.)
~~~

Monoids: less trivial examples
==============================
~~~{.haskell .ignore}
data Max a = Max { getMax :: a }

instance (Ord a, Bounded a) => Monoid (Max a)
  where
    mempty = Max minBound
    mappend = max

data Uhrzeit = Uhrzeit { stunde :: Int
                       , minute :: Int
                       , sekunde :: Int
                       }

instance Monoid Uhrzeit where
  mempty = Uhrzeit 0.0 0.0 0.0
  mappend d1 d2 = ???
~~~


Monoid: log summaries
=====================
~~~{.haskell .ignore}
data LogEntry = { user :: User
                , duration :: Double
                , spent :: Double}
data LogSummary = LS { users :: Set User,
                     , totalDuration :: Double
                     , moneySpent :: Double}

instance Monoid LogSummary where
  mempty = LS [] 0.0
  (LS us ds ms) <> (LS vs es ls) =
    LS (us `union` vs) ds+ es ls+ms

report :: [LogEntry] -> LogSummary
report entries =
  mconcat $ map entryToSummary entries
~~~

Monoid: Distributions
=====================
~~~{.haskell .ignore}
data Gaussian = Gaussian { n :: Int
                         , mean :: Double
                         , var  :: Double}

instance Monoid Gaussian where
  mempty = Gaussian 0 0.3 0.4
  (Gaussian n1 m1 v1) <> (Gaussian n2 m2 v2) =
    Gaussian n3 m3 v3 where
      n3 = n1 + n2
      m3 = (n1*m1 + n2*m2)/n3
      v3 = v2 + n1*v1*v1 + v2 + n2*v2*v2
           - n3*m3*m3
~~~
