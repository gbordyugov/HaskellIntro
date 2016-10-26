% Intro to Haskell, day 1
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

~~~{.haskell}
import Prelude hiding (concat)
~~~

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

~~~{.haskell .ignore}
addThree 5 -- => 8
~~~

Explanation:

~~~{.haskell .ignore}
add :: Double -> Double -> Double
~~~

is equivalent to

~~~{.haskell .ignore}
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

~~~{.haskell .ignore}
head numbers -- => 1
tail numbers -- => [2, 3, 4]
take 3 numbers -- => [1, 2, 3]

take 5 [1..] -- => [1, 2, 3, 4, 5]

map :: (a -> b) -> [a] -> [b]

map (1+) numbers -- => [2, 3, 4, 5]
map (*2) numbers -- => [2, 4, 6, 8]
~~~

Infinite Fibonacci Sequence
===========================

We use

~~~{.haskell .ignore}
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
~~~

such as in

~~~{.haskell .ignore}
zipWith (+) [1, 2, 3] [3, 2, 1]
-- => [4, 4, 4]
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

~~~{.haskell .ignore}
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
mySum (x:xs) = x + mySum xs
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

~~~{.haskell .ignore}
"Old McDonald had a" ++ "farm"
~~~

When concatenating a large number of lists, how to ensure right
associativity?

In other words, we want to ensure

~~~{.haskell .ignore}
"Old" ++ ("McDonald had a" ++ "farm")
~~~
instead of

~~~{.haskell .ignore}
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
-- concat a b = \x -> (a . b) x
showdl x   = x []

(j, h) = (dlist "jacke", dlist "hose")
jh     = concat j h
jhjh   = concat jh jh
~~~

~~~{.haskell .ignore}
showdl jhjh -- => "jackehosejackehose"

(f . g . h) x
~~~

associates always to the right!
