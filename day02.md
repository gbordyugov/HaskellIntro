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
reverseWords "bla bli blu" -- => "alb ilb ulb"
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
c = [p] -> [q]
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

Understand and derive the type of

~~~haskell
map map :: [a -> b] -> [[a] -> [b]]
~~~
