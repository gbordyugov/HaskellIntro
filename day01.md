% Intro to Haskell
% G Bordyugov
% Oct 2016

Haskell language
================

Language
--------
- Pure: there is no state
- Strongly typed: each value has a type
- Algebraic (container) types
- Lazily evaluated (infinitely large data structures)
- Compiles to native code plus interpreter ala ipython
- Consequence of purity: code easy to parallelize

Haskell language
================

History & Ecosystem
-------------------
- Designed in academia in the eighties
- Now widely employed in industry, including: Facebook, Standard Chartered,
  AT&T, Bank of America, Barclays, etc
- Large body of packages (Hackage)
- Great online help (Hoogle)

Haskell language
================

My personal impression
----------------------
- Steep learning curve in the beginning
- Since couple of years, tons of great books
- Mathematical (category theory)
- If your program compiles, it most probably works as expected

Today: Functions and (some) Types
=================================

Functions
=========

~~~haskell
f :: Double -> Double
f x = x*x

plus :: Double -> Double -> Double
plus x y = x+y

fib :: Integer -> Integer
-- pattern matching
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
~~~

Partial application
===================

Trick:

~~~haskell
add :: Double -> Double -> Double
add x y = x+y
addThree = add 3
~~~

~~~haskell
addThree 5 -- => 8
~~~

Explanation:

~~~haskell
add :: Double -> Double -> Double
~~~

is equivalent to

~~~haskell
add :: Double -> (Double -> Double)
~~~

mapping a double to a function of type Double -> Double

Tuples
=======
~~~haskell
myTuple = (5, "AmbroSys")

-- pattern matching again
fst (a, b) = a
snd (a, b) = b
~~~

Here, __a__ and __b__ are _variables_

~~~haskell
fst :: (a, b) -> a
snd :: (a, b) -> b
~~~

Here, __a__ and __b__ are _type variables_, can be _any_ types,
including functions

Type signature can be really instructive

Lists
=====

~~~haskell
numbers = [1, 2, 3, 4]
-- equivalent to 1:[2, 3, 4]
-- equivalent to 1:2:[3, 4], etc
~~~

~~~haskell
head numbers -- => 1
tail numbers -- => [2, 3, 4]
take 3 numbers -- => [1, 2]

take 5 [1..] -- => [1, 2, 3, 4, 5]

map :: (a -> b) -> [a] -> [b]

map (1+) numbers -- => [2, 3, 4, 5]
map (*2) numbers -- => [2, 4, 6, 8]
~~~

Infinite Fibonacci Sequence
===========================

We use

~~~haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
~~~

such as in

~~~haskell
zipWith (+) [1, 2, 3] [3, 2, 1]
-- => [5, 5, 5]
~~~

to write

~~~haskell
fibs = 0:1:(zipWith (+) fibs (tail fibs))
~~~

mind blowing, eh?

Strings = Lists of Chars
========================

~~~haskell
string = "Old McDonald had a farm"
~~~

~~~haskell
head string -- => 'O'
take 3 string -- => "Old"
words string -- => ["Old", "McDonald", "had",
             --     "a", "farm"]

"Ambro" ++ "Sys" -- => "AmbroSys"

map toUpper string -- => "OLD MCDONALD
                   --     HAD A FARM"
-- function composition by dot
(length . words) string -- => 5

numOfWords = length . words -- point-free notation
~~~

Recursion over Lists
====================

~~~haskell
mySum :: [Double] -> Double
-- empty list
mySum [] = 0
-- non-empty list
mySum (x:xs) = x + sum xs
~~~

Something slightly different:

~~~haskell
myLength [] = 0
myLength (x:xs) = 1 + myLength xs
~~~

type of myLength?

~~~haskell
myLength :: [a] -> Integer
~~~

Polymorphism!

Project: Difference Lists
=========================

Problem: for single-linked lists, concatenation can be expensive if the
first list happens to be long

~~~haskell
"Old McDonald had a" ++ "farm"
~~~

When concatenating a large number of lists, how to ensure right
associativity?

In other words, we want to ensure

~~~haskell
"Old" ++ ("McDonald had a" ++ "farm")
~~~
instead of

~~~haskell
("Old" ++ "McDonald had a") ++ "farm"
~~~

Difference Lists
================

From Wiki: A difference list represents lists as a function __dlist__,
which when given a list __x__, returns the list that __dlist__
represents, _prepended_ to __x__. 

~~~haskell
dlist  y   = \x -> y ++ x
concat a b = \x -> a (b x)
showdl x   = x ""

(j, h) = (dlist "jacke", dlist "hose")
jh     = concat j h
jhjh   = concat jh jh
showdl jhjh -- => "jackehosejackehose"

(f . g . h) x
~~~
associates always to the right!

Types: Simple Sum Types
===================

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

z1 :: Complex
z2 :: Complex
z1 = Cartesian 1.0  2.0
z2 = Polar     1.0  pi/2.0
~~~

both have the same type Complex, we must be able to do arythmetic
independently on the representation

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

Syntactic sugar
===============
Haskell supports user-defined _infix_ functions, for example, we can
define

~~~haskel
(<+>) = add
(<->) = sub
(<*>) = mul
(</>) = div
~~~

for fun and profit:


~~~haskel
z = (z1 <+> z2) </> (z1 <-> z2) <*> z1
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

Container Types: List
=====================

~~~haskell
data List a = Nil
            | Cons a (List a)
~~~

__A recursive type!__

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


The mighty dot
==============

Write the type signature and definition of the function composition (.)

The mighty dot
==============

~~~haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
(.) f g = \x -> f (g x)
~~~


Some one liners
===============

- Fibonacci numbers

~~~haskell
fibs = 0:1:zipWith (+) fibs (tail fibs)
~~~

- Powers of two

~~~haskell
powers = iterate (*2) 1
~~~

Last slide
==========


