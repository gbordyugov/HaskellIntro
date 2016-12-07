% Intro to Haskell, day 7
% G Bordyugov
% Dec 2016


Today
=====

0. Monads recap
1. The `Maybe` monad
2. Lists as a monad
3. The `State` monad

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
Context: computations that can optionally fail

~~~{.haskell .ignore}
instance Monad Maybe where
  return :: a -> Maybe a
  return x = Just x

  (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
  Nothing  >>= f = Nothing
  (Just x) >>= f = f x

  (>>) :: Maybe a -> Maybe b -> Maybe b
  Nothing >> x = Nothing
  x >> Nothing = Nothing
  (Just x) >> (Just y) = Just y
~~~

`Maybe` monad: why?
===================
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


Lists as a monad
================
Context: non-deterministic computations, i.e. returning multiple
outcomes

~~~{.haskell .ignore}
instance Monad [] where
  return :: a -> [a]
  return x = [x]

  (>>=) :: [a] -> (a -> [b]) -> [b]
  as >>= f = [b | a <- as, b <- f a]
  
  (>>) :: [a] -> [b] -> [b]
  as >> bs = bs
~~~~

Lists as a monad: example
=========================
Our ``F*cebook''-application with

~~~{.haskell .ignore}
getFriends :: User -> [Users]
~~~

Getting friends of friends:


~~~{.haskell .ignore}
getFriendsOfFriends :: User -> [User]
getFriendsOfFriends u = do
  f  <- getFriends u
  ff <- getFriends f
  return ffriend
~~~

Equivalent to

~~~{.haskell .ignore}
getFriendsOfFriends u =
  [ff | f <- getFriends u, ff <- getFriends f]
~~~

The State monad
===============
Context: stateful computations


~~~{.haskell .ignore}
newtype State s a =
  State { runState :: s -> (a, s) }
~~~

As mentioned a couple of weeks ago, this automatically introduces the
accessor

~~~{.haskell .ignore}
runState :: State s a -> (s -> (a, s))
~~~

Testfrage: what about functions accepting more than state, i.e.

~~~{.haskell .ignore}
f :: b -> s -> (a, s)
~~~

?
                       


