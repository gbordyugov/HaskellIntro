% Intro to Haskell, day 6
% G Bordyugov
% Nov 2016


Today
=====

0. Types recap
1. Monads

Higher-kind types
=================

~~~{.haskell .ignore}
data Maybe a = Nothing
             | Just a

data List a = Nil
            | Cons a (List a)

data Tree a = Leaf
            | Node a (Tree a) (Tree a)
~~~

Examples:

~~~{.haskell .ignore}
type MaybeDouble = Maybe Double
type TreeOfInts = Tree Int
type ListOfListsOfChar = List (List Char)
~~~

Monad typeclass
===============
~~~{.haskell .ignore}
class Monad m where
  return :: a -> m a
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b

~~~

For example, if `m = Maybe`:

~~~{.haskell .ignore}
  return :: a -> Maybe a
  (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
  (>>) :: Maybe a -> Maybe b -> Maybe b
~~~

`Maybe` monad
=============
~~~{.haskell .ignore}
instance Monad Maybe where
  return x = Just x

  a >>= f :: Maybe a -> (a -> Maybe b) -> Maybe B
  Nothing  >>= _ = Nothing
  (Just x) >>= f = Just (f x)

  (>>) :: Maybe a -> Maybe b -> Maybe b
  Nothiing >> _ = Nothing
  _ >> Nothing  = Nothing
  (Just x) >> (Just y) = Just y
~~~

`Maybe` monad: why?
==================
Composing math functions:

~~~{.haskell .ignore}
sqrt   :: Double -> Maybe Double
arcsin :: Double -> Maybe Double
arccos :: Double -> Maybe Double
~~~

without monads:

~~~{.haskell .ignore}
asa x = case arcsin x of
  Nothing -> Nothing -- shortcut
  Just x  -> case sqrt x of
    Nothing -> Nothing -- shortcut
    Just y  ->  arccos y
~~~

`Maybe` monad: why?
==================
Composing math functions:

~~~{.haskell .ignore}
sqrt   :: Double -> Maybe Double
arcsin :: Double -> Maybe Double
arccos :: Double -> Maybe Double
~~~

with monads:

~~~{.haskell .ignore}
asa x =
   arcsin x  >>=   sqrt    >>=  arccos

::   m a     -> (a -> m a) -> (a -> m a)
~~~

`Maybe` monad: why?
==================
Looking ups

~~~
phonebook :: [(String, String)]
phonebook = [ ("Bob",   "01788 665242"),
              ("Fred",  "01624 556442"),
              ("Alice", "01889 985333"),
              ("Jane",  "01732 187565") ]
~~~

~~~{.haskell .ignore}
lookup :: Eq a => a  -- a key
       -> [(a, b)]   -- the lookup table to use
       -> Maybe b    -- the result of the lookup
~~~

~~~
Prelude> lookup "Bob" phonebook
Just "01788 665242"
Prelude> lookup "Zoe" phonebook
Nothing
~~~

`Maybe` monad: why?
==================
~~~
cars :: [(String, String)]
cars = [ ("01788 665242", "P 101 BA"),
         ("01732 187565", "B 4242 D") ]
~~~

~~~{.haskell .ignore}
getCarPlate :: String
            -> Maybe String

getCarPlate name =
  lookup name phonebook >>=
    (\number -> lookup number cars)
~~~

Do-notation for monads
=====================
~~~{.haskell .ignore}
getCarPlate :: String
            -> Maybe String

getCarPlate name =
  lookup name phonebook >>=
    (\number -> lookup number cars)
~~~

is equivalent to

~~~{.haskell .ignore}
getCarPlate name = do
  number <- lookup name phonebook
  return (lookup number cars)
~~~

Do-notation for monads
=====================
~~~{.haskell .ignore}
asa a = arcsin a >>= sqrt >>= arccos
~~~

can be written as

~~~{.haskell .ignore}
asa a =
  arcsin a >>= (\b ->
    sqrt b   >>= (\c ->
      arccos c >>= (\d -> return d)))
~~~

and hence

~~~{.haskell .ignore}
asa a = do
  b <- arcsin a
  c <- sqrt b
  d <- arccos c
  return d
~~~
