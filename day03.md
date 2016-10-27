% Intro to Haskell, day 3
% G Bordyugov
% Oct 2016


Today
=====

0. Home Exercise
1. Algebraic Data Types

~~~{.haskell}
import Prelude hiding (abs, div)
~~~

Home Exercise
=============

Understand and derive the type of

~~~{.haskell .ignore}
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
seqA = [A, A, C, G, T, T]
seqB = map complement seqA
~~~

Types contd: Sum types
======================

Two parallel representations of complex numbers

~~~haskell
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

Two constructors:

~~~{.haskell .ignore}
Cartesian :: Double -> Double -> Complex
Polar     :: Double -> Double -> Complex
~~~

~~~{.haskell}
z1 = Cartesian 1.0  2.0
z2 = Polar 1.0  (pi/2.0)

xs = zipWith Cartesian [1, 2, 3, 2] [4, 5, 6, 1]
ys = zipWith Polar [1, 1, 1] [0.0, pi/2.0, pi]
~~~

Types contd: Sum types
======================

~~~{.haskell .ignore}
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

~~~{.haskell}
add a b = Cartesian (re a + re b) (im a + im b)
sub a b = Cartesian (re a - re b) (im a - im b)
mul a b =
  Polar ((abs a)*(abs b)) (arg a + arg b)
div a b =
  Polar ((abs a)/(abs b)) (arg a - arg b)
~~~

Syntactic Sugar
===============
Haskell supports user-defined _infix_ functions, for example, we can
define

~~~{.haskell}
(<+>) = add
(<->) = sub
(<*>) = mul
(</>) = div
~~~

for fun and profit:


~~~{.haskell}
z = (z1 <+> z2) </> (z1 <-> z2)
zs = zipWith (<+>) xs ys
  where
  xs = zipWith Cartesian [1, 2, 3] [4,  5, 6]
  ys = zipWith Polar     [1, 1, 2] [0, pi, pi]
~~~

Syntactic Sugar
===============
In general, special symbol functions are __infix__ by default:

~~~{.haskell}
a = 5 + 3
~~~

but can be used in __prefix__ notation:

~~~{.haskell}
b = (+) 5 3
~~~

Alpha-numerical functions are by default __prefix__:

~~~{.haskell}
plus = (+)
c = plus 2 3
~~~

but can be used in __infix__ notation with backquotes:

~~~{.haskell}
d = 2 `plus` 3
~~~


Types contd: Sum types
======================

Given the following type for complex numbers

~~~{.haskell .ignore}
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

implement __re__, __im__, __abs__, and __arg__

Types contd: Sum types
======================

~~~{.haskell .ignore}
data Complex = Cartesian Double Double
             | Polar     Double Double
~~~

~~~{.haskell}
re (Cartesian x y) = x
re (Polar r theta) = r * cos theta

im (Polar r theta) = r * sin theta
im (Cartesian x y) = y

abs (Cartesian x y) = sqrt (x*x + y*y)
abs (Polar r theta) = r

arg (Cartesian x y) = atan2 y x
arg (Polar r theta) = theta
~~~

Recursive Types
===============

~~~{.haskell}
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

~~~{.haskell}
data List a = Nil
            | Cons a (List a)
~~~

Recursion on list:

~~~{.haskell}
myLength :: List a -> Integer
myLength Nil = 0
myLength (Cons x xs) = 1 + myLength xs

myMap :: (a -> b) -> List a -> List b
myMap f Nil = Nil
myMap f (Cons x xs) = Cons (f x) (myMap f xs)
~~~

as a matter of fact:

~~~{.haskell .ignore}
data [a] = [] | a:[a]
~~~

Container Types: Binary Tree
============================

~~~{.haskell}
data Tree a = Leaf
            | Node a (Tree a) (Tree a)

depth :: Tree a -> Int
depth Leaf = 0
depth (Node x left right) = 1 + d
  where d = max (depth left) (depth right)

treeMap :: (a -> b) -> Tree a -> Tree b
treeMap f Leaf = Leaf
treeMap f (Node x left right) =
  Node (f x) (treeMap f left) (treeMap f right)
~~~


A Custom DSL for Arithmetic Expressions
=======================================

~~~{.haskell}
data Expr = Constant Double
          | Negate Expr
          | Plus Expr Expr
          | Minus Expr Expr

eval :: Expr -> Double
eval (Constant a) = a
eval (Negate e) = - eval e
eval (Plus x y) = (eval x) + (eval y)
eval (Minus x y) = (eval x) - (eval y)

exp = Negate (Plus (Constant 1)
              (Minus (Constant 3)(Constant 2)))
~~~

A Custom DSL for Arithmetic Expressions
=======================================

~~~{.haskell}
data Ausdruck = Konstant Double
              | Unitary UnitaryOp Expr
              | Binary BinaryOp Expr Expr

data BinaryOp  = Add | Sub | Mul | Div
data UnitaryOp = Neg | Abs | Sin | Cos
~~~

Records Style
=============

The type declaration

~~~{.haskell}
data RUser = RUser { userName :: String
                   , userFriends :: [User]
                   }
~~~

__automatically__ introduces all accessors:

~~~{.haskell .ignore}
userName :: RUser -> String
userName (RUser x _) = x

userFriends :: RUser -> [RUser]
userFriends (RUser _ x) = x
~~~

might be an advantage as well as disadvantage

Records Style
=============

New declaration for `Complex` might be

~~~{.haskell}
data Komplex = Kartesian { reP :: Double 
                         , imP :: Double}
             | Polr { rad :: Double
                    , ang :: Double}
~~~

re, im, abs, and arg are auto-generated
by compiler, but

~~~{.haskell .ignore}
rad $ Kartesian 1.0 2.0
-- would cause an error
~~~
