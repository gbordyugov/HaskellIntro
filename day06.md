% Intro to Haskell, day 6
% G Bordyugov
% Nov 2016


Today
=====

0. Types recap
1. Functors
2. Applicative Functors
3. Monads

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

Functor typeclass
=================
~~~{.haskell .ignore}
class Functor f where
  fmap :: (a -> b) -> f a - > f b

(<$>) = fmap
~~~

`Maybe` as functor
==================
~~~{.haskell .ignore}
instance Functor Maybe where
  fmap f Nothing = Nothing
  fmap f (Just x) = Just (f x)

fmap (+3) (Just 5) => Just 8
fmap (+3) Nothing => Nothing
~~~

`Tree` as functor
=================
~~~{.haskell .ignore}
instance Functor Tree where
  fmap f Leaf = Leaf
  fmap f (Node a l r) =
    Node (f a) (fmap f l) (fmap f r)
~~~

Function application as functor
===============================
For `f = (->) r`:

~~~{.haskell .ignore}
instance Functor ((->) r) where
    fmap f g = (\x -> f (g x))
~~~

Type signature:


~~~{.haskell .ignore}
fmap :: (a -> b) ->   f a    ->   f b =
        (a -> b) -> (->) r a -> (->) r b =
        (a -> b) -> (r -> a) -> (r -> b)
~~~

or in other words

~~~{.haskell .ignore}
instance Functor ((->) r) where
    fmap = (.)

fmap (*3) (+100) 1 => 303
~~~

List as functor
===============
~~~{.haskell .ignore}
instance Functor [a] where
    fmap = map
~~~

IO actions as functor
=====================
~~~{.haskell .ignore}
instance Functor IO where
  fmap = ... -- see later

getLine :: IO String
getInt = fmap read getLine :: IO Int
fmap (+3) getInt :: IO Int
~~~


Context is important
====================
~~~{.haskell .ignore}
fmap (replicate 3) [1,2,3,4] =>
[[1,1,1],[2,2,2],[3,3,3],[4,4,4]]

fmap (replicate 3) (Just 4) =>
Just [4,4,4]

fmap (replicate 3) (Right "blah") =>
Right ["blah","blah","blah"]

fmap (replicate 3) Nothing =>
Nothing

fmap (replicate 3) (Node 3 (Node 5 Leaf Leaf) Leaf) =>
Node [3,3,3] (Node [5,5,5] Leaf Leaf) Leaf
~~~

Applicative typeclass: motivation
=================================
~~~{.haskell .ignore}
fmap (+) (Just 3) =>
Just (+3) :: Maybe (Int -> Int)

fmap (+) [1, 2, 3] =>
[(+1), (+2), (+3)]:: [ Int -> Int ]
~~~

Would be nice if we could do

~~~{.haskell .ignore}
[(+1), (+2), (+3)] <*> [1, 2] =>
[2,3,3,4,4,5]

<*> :: f (a -> b) -> f a -> f b
~~~

but Functor cannot do it!

Applicative typeclass
=====================
~~~{.haskell .ignore}
class (Functor f) => Applicative f where
    pure  :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
~~~

`Maybe` as Applicative
======================
~~~{.haskell .ignore}
instance Applicative Maybe where
    pure                  = Just
    (Just f) <*> (Just x) = Just (f x)
    _        <*> _        = Nothing

Just (+5) <*> Just 3  => Just 8
Just (+5) <*> Nothing => Nothing
Nothing   <*> Just 3  => Nothing

(+) <$> (Just 5) <*> Just 3 => Just 8
~~~

List as Applicative
===================
~~~{.haskell .ignore}
instance Applicative [] where
    pure x    = [x]
    fs <*> xs = [f x | f <- fs, x <- xs]

[(+1), (+2), (+3)] <*> [1, 2] =>
[2,3,3,4,4,5]

(+) <$> [1,2,3] <*> [1,2] =>
[2,3,3,4,4,5]

[(+1), (+2), (+3)] <*> (Just 3) =>
ERROR
~~~

IO as Applicative
==================
to get two lines:

~~~{.haskell .ignore}
getToLines = (++) <$> getLine <*> getLine
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
  Nothing >> _ = Nothing
  _ >> Nothing = Nothing
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

::   m a     -> (a -> m a) -> m a
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
