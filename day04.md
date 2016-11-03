% Intro to Haskell, day 4
% G Bordyugov
% Nov 2016


Today
=====

0. List origami with folds
1. Type classes

~~~{.haskell}
import Prelude hiding (foldr, foldl, foldl')
~~~

Recursion on lists
==================
~~~{.haskell}
myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs


mySum :: [Int] -> Int
mySum [] = 0
mySum (x:xs) = x + mySum xs

myProd :: [Int] -> Int
myProd [] = 1
myProd (x:xs) = x * myProd xs
~~~

Recursion on lists
==================
~~~{.haskell}
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (x:xs) = x && myAnd xs

myOr :: [Bool] -> Bool
myOr [] = False
myOr (x:xs) = x || myOr xs

myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs
~~~

`foldr`
=====
~~~{.haskell}
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)
~~~

`z` is substitute for the empty list `[]`: starting value

`f x xs` is substitute for `x : xs`: combining things

<div align="center">
<img align="center" src="foldr.png", style="width: 420px;"/>
</div>

What do we win by using `foldr`?
==========================
... avoiding explicit recursion!

~~~haskell
fLength = foldr (\a b -> b+1) 0
fSum    = foldr (+) 0
fProd   = foldr (*) 1
fAnd    = foldr (&&) True
fOr     = foldr (||) False

-- ... many more functions on lists
~~~

Exercise: step through `fSum [1, 2, 3]`

Exercise: express `map` through `foldr`

Expressing `map` through `foldr`
===============================
~~~{.haskell .ignore}
myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)
~~~

Expressing `map` through `foldr`
===============================
~~~haskell
fMap f = foldr (\x xs -> f x : xs) []
~~~

Just scraping the surface...
============================
There are:

~~~haskell
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f z [] = z
foldl f z (x:xs) = foldl f (f z x) xs
~~~

`foldl'` (strict version), `foldr1`, ...

Exercise: step through `foldl (+) 0 [1, 2, 3]`

Home exercise: express `foldl` by `foldr` (the other way around is not
possible).

Typeclasses
===========
~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

How to print them? Anything like `toString()` in Java?

Yes! Make `Complex` an instance of __typeclass__ `Show`:

~~~{.haskell .ignore}
class Show a where
  show :: a -> String
~~~

Making `Complex` showable
=========================
~~~haskell
instance Show Complex where
  show (Cartesian x y) =
    show x ++ " + " ++ show y ++ "i"
  show (Polar r theta) =
    "radius: "  ++ show r ++ 
    ", angle: " ++ show theta

s1 = show $ Cartesian 1.0 2.0
-- => s1 = "1.0 + 2.0i"
s2 = show $ Polar 1.0 2.0
-- => s2 = "radius: 1.0, angle: 2.0"
~~~

Making `Complex` showable an easy way
=====================================
~~~{.haskell .ignore}
data Complex = Cartesian Double Double
             | Polar     Double Double
             deriving (Show)
~~~

Not always the best representation

Exercise: `User`
===============
Make the following data type an instance of `Show`

~~~haskell
data User = User String [User]
~~~

Check with

~~~haskell
markus = User "Markus" [grisha, thomas]
thomas = User "Thomas" [grisha, markus]
grisha = User "Grisha" [thomas, markus]
~~~

Exercise: `User`
===============
Make the following data type an instance of `Show`

~~~{.haskell .ignore}
data User = User String [Users]
~~~

~~~haskell
instance Show User where
  show (User name friends) =
    "User: " ++ name ++
    ", friends: " ++
    concat (map (\(User n _) -> n ++ " ")
            friends)
~~~

Other typeclasses
=================
- `Eq` for things that can be tested for equality
- `Ord` for things that can be compared
- `Num` for number-like (`Int, Integer, Double, Rational, ...`)
- `Read` is inverse to `Show`
- `Foldable`
- `VectorSpace`, `Group`, etc., etc.,
- `Functor`, `Monoid`, `Applicative`, `Monad` to screw your brain ;-)

Exercise: Comparing complex numbers
===================================
~~~{.haskell .ignore}
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

Derive an instance of `Eq`:

~~~{.haskell .ignore}
class Eq a where
  (==) :: a -> a -> Bool
~~~

Exercise: Comparing complex numbers
===================================
~~~{.haskell .ignore}
instance Eq Complex where
 (==) a b = (re a == re b) && (im a == im b)
~~~
