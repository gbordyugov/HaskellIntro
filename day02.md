% Intro to Haskell, day 2
% G Bordyugov
% Oct 2016


Today
=====

0. Get some coffee - you'll need your grey matter :-)
1. Exercises with lists and maps
2. Algebraic data types

Refresher: Strings
====================

Using

~~~haskell
map :: (a -> b) -> [a] -> [b]
reverse :: String -> String
words :: String -> [String]
unwords :: [String] -> String
~~~

write a function that will reverse letters in all words in a string.

I.e.

~~~haskell
reverseWords "bla bli blu" -- => "abl ibl ubl"
~~~

Check the type of the `reverseWords`.

Refresher: Strings
====================

Using

~~~haskell
map :: (a -> b) -> [a] -> [b]
reverse :: String -> String
words :: String -> [String]
unwords :: [String] -> String
~~~

write a function that will reverse letters in all words in a string.
Solution:

~~~haskell
reverseWords :: String -> String
reverseWords = unwords . (map reverse) . words
~~~

The mighty dot
==============

Write the type signature and definition of the function composition
(.), as in

~~~haskell
countWords :: String -> Int
countWords = length . words
~~~

(`words` splits a string into single words by spaces)


The mighty dot
==============

~~~haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
~~~

Prefix and infix notations can be used interchangeably:

~~~haskell
-- either
f . g = \x -> f (g x)

-- or
(.) f g = \x -> f (g x)
~~~



Higher-order mapping
====================

~~~haskell
map :: (a -> b) -> [a] -> [b]

map (+1) [1, 2, 3] -- => [2, 3, 4]

map (+1) [[1, 2], [3, 4], [5,6]]
-- => type error, won't even compile
~~~

Solution:


~~~haskell
(map . map) (+1) [[1, 2], [3, 4], [5,6]]
~~~

Clear separation of what to do `(+1)` and the data structure access
`(map . map)`.

Very common pattern in Haskell!


Untangling `(map . map)`
========================

We have for `(map . map)`

~~~haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)

map :: (u -> v) -> ([u] -> [v])



map :: (p -> q) -> ([p] -> [q])


~~~

Untangling `(map . map)`
========================

We have for `(map . map)`

~~~haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)

map :: (u -> v) -> ([u] -> [v])
       --------    ------------
          a     ->       b

map :: (p -> q) -> ([p] -> [q])
       --------    ------------
          b     ->       c
~~~


Untangling `(map . map)`
========================
from those types, it follows:

~~~
a = u -> v
b = [u] -> [v]
b = p -> q
c = [p] - [q]
~~~

From here, it follows that `p = [u], q = [v]`
and following 

~~~
c = [p] -> [q] = [[u]] -> [[v]]
~~~

and finally the type of `(map . map)`

~~~
a -> c = (u -> v) -> ([[u]] -> [[v]])
~~~

Ta-da!

Home Exercise
=============

Understand and derive type of

~~~haskell
map map :: [a -> b] -> [[a] -> [b]]
~~~

Types: Simple Sum Types
=======================

Simple types

~~~haskell
data Nucleotide = A | C | G | T

complement A = T
complement C = G
complement G = C
complement T = A

myNuc = A
myAnotherNuc = C
map complement [A, A, C, G, T, T]
~~~

Types contd: Sum types
======================

Two parallel representations of complex numbers

~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

Two constructors:

~~~haskell
Cartesian :: Double -> Double -> Complex
Polar     :: Double -> Double -> Complex

z1 = Cartesian 1.0  2.0
z2 = Polar 1.0  pi/2.0

xs = zipWith Cartesian [1, 2, 3, 2] [4, 5, 6, 1]
ys = zipWith Polar [1, 1, 1] [0.0, pi/2.0, pi]
~~~

Types contd: Sum types
======================

~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double

add a b = Cartesian (re a + re b) (im a + im b)
sub a b = Cartesian (re a - re b) (im a - im b)
mul a b =
  Polar (abs a)*(abs b) (arg a + arg b)
div a b =
  Polar (abs a)/(abs b) (arg a - arg b)
~~~

Syntactic Sugar
===============
Haskell supports user-defined _infix_ functions, for example, we can
define

~~~haskell
(<+>) = add
(<->) = sub
(<*>) = mul
(</>) = div
~~~

for fun and profit:


~~~haskell
z = (z1 <+> z2) </> (z1 <-> z2)
zs = zipWith (<+>) xs ys
  where
  xs = map Cartesian [1, 2, 3], [4,  5, 6]
  ys = map Polar     [1, 1, 2], [0, pi, pi]
~~~

Syntactic Sugar
===============
In general, special symbol functions are __infix__ by default:

~~~haskell
x = 5 + 3
~~~

but can be used in __prefix__ notation:

~~~haskell
x = (+) 5 3
~~~

Alpha-numerical functions are by default __prefix__:

~~~haskell
z1 = plus x1 y1
~~~

but can be used in __infix__ notation with backquotes:

~~~haskell
z1 = x1 `plus` y1
~~~


Types contd: Sum types
======================

Given the following type for complex numbers

~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

implement __re__, __im__, __abs__, and __arg__

Types contd: Sum types
======================

~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double

re (Cartesian x y) = x
im (Cartesian x y) = y
re (Polar r theta) = r * cos theta
im (Polar r theta) = r * sin theta

abs (Cartesian x y) = sqrt (x*x + y*y)
arg (Cartesian x y) = atan2 y x
abs (Polar r theta) = r
arg (Polar r theta) = theta
~~~

Recursive Types
===============

~~~haskell
data User = User String -- name
                 [User] -- list of friends

makeUser :: String -> User
makeUser name = User name [] -- no friends

addFriend :: User -> User -> User
addFriend (User name fs) f = User name (f:fs)

users = map makeUser ["Horst", "Willi", "Jana"]

(<--) = addFriend
markus = makeUser "Markus"
thomas = makeUser "Thomas" <-- markus
                           <-- makeUser "Grisha"
~~~

Container Types: List
=====================

~~~haskell
data List a = Nil
            | Cons a (List a)
~~~

Recursion on list:

~~~haskell
myLength :: List a -> Integer
myLength Nil = 0
myLength (Cons x xs) = 1 + myLength xs

myMap :: (a -> b) -> List a -> List b
myMap f Nil = Nil
myMap f (Cons x xs) = Cons (f x) (myMap xs)
~~~

as a matter of fact:

~~~haskell
data [a] = [] | a:[a]
~~~

Container Types: Binary Tree
============================

~~~haskell
data Tree a = Leaf a
            | Node a (Tree a) (Tree a)

depth :: Tree a -> Int
depth (Leaf x) = 1
depth (Node x left right) = 1 + d
  where d = max (depth left) (depth right)

treeMap :: (a -> b) -> Tree a -> Tree b
treeMap f (Leaf x) = Leaf (f x)
treeMap f (Node x left right) =
  Node (f x) (treeMap f left) (treeMap f right)

~~~


A Custom DSL for Arithmetic Expressions
=======================================

~~~haskell
data Expr = Constant Double
          | Negate Expr
          | Plus Expr Expr
          | Minus Expr Expr

eval :: Expr -> Double
eval (Constant a) = a
eval (Negate e) = -e
eval (Plus x y) = (eval x) + (eval y)
eval (Minus x y) = (eval x) - (eval y)

exp = Negate (Plus 1 (Minus 3 2))
~~~

A Custom DSL for Arithmetic Expressions
=======================================

~~~haskell
data Expr = Constant Double
          | Unitary UnitaryOp Expr 
          | Binary BinaryOp Expr Expr

data BinaryOp  = Add | Sub | Mul | Div | ...
data UnitaryOp = Negate | Abs | Sin | Cos | ...
~~~

Records Style
=============

The type declaration

~~~haskell
data User = User { userName :: String
                 , userFriends :: [User]
                 }
~~~

__automatically__ introduces all accessors:

~~~haskell
userName :: User -> String
userName (User x _) = x

userFriends :: User -> [User]
userFriends (User _ x) = x
~~~

might be an advantage as well as disadvantage

Records Style
=============

New declaration for `Complex` might be

~~~haskell
data Complex = Cartesian { re :: Double 
                         , im :: Double}
             | Polar { abs :: Double
                     , arg :: Double}

-- re, im, abs, and arg are auto-generated
-- by compiler, but
abs $ Cartesian 1.0 2.0
-- would cause an error
~~~
