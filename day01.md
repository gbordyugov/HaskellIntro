% Intro to Haskell
% G Bordyugov
% AmbroSys, Oct 2016

Haskell language
================

Language
--------
- Pure: there is no state
- Strongly typed: each value has a type
- Algebraic types
- Lazily evaluated (infinitely large data structures)
- Compiles to native code plus interpreter ala ipython
- Consequence of purity: easily parallelizeable

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

Today: Functions and Types
==========================

Functions
=========

~~~haskell
square :: Double -> Double
square x = x*x

plus :: Double -> Double -> Double
plus x y = x+y

fib :: Integer -> Integer
-- pattern matching
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-1)
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

map (1+) numbers -- => [2, 3, 4, 5]
map (*2) numbers -- => [2, 4, 6, 8]

zipWith (*) numbers (map (+1) numbers) -- => ?
~~~

Lists of Chars
==============

~~~haskell
string = "Old McDonald had a farm"
~~~

~~~haskell
words string -- => ["Old", "McDonald", "had",
             --     "a", "farm"]
head string -- => 'O'
take 3 string -- => "Old"

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

Project: Difference lists
================

Problem: for single-linked lists, concatenation can be expensive if the
first list happens to be long

~~~haskell
"Old McDonald had a" ++ "farm"
~~~

When concatenating a large number of lists, how to ensure the right
associativity?

In other words, we want to ensure

~~~haskell
"Old" ++ ("McDonald had a" ++ "farm")
~~~
instead of

~~~haskell
("Old" ++ "McDonald had a") ++ "farm"
~~~

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
