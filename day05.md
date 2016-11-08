% Intro to Haskell, day 5
% G Bordyugov
% Nov 2016


Today
=====

0. Folds, folds, folds
1. Monoids

~~~{.haskell}
import Prelude hiding (foldr, foldl)
~~~

Right fold
==========
Definition:

~~~{.haskell}
foldr :: (b -> a -> a) -> a -> [b] -> a
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)
~~~

An example expansion:

~~~{.haskell .ignore}
foldr (+) 0 [1, 2, 3, 4, 5] =>
1 + (foldr (+) 0 [2, 3, 4, 5]) =>
1 + (2 + (foldr (+) 0 [3, 4, 5])) =>
1 + (2 + (3 + (foldr (+) 0 [4, 5]))) =>
... =>
1 + (2 + (3 + (4 + (5 + 0))))
~~~

Left fold
=========
Definition:

~~~{.haskell}
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f z []     = z
foldl f z (x:xs) = foldl f (f z x) xs
~~~

An example expansion:

~~~{.haskell .ignore}
foldl (+) 0 [1, 2, 3, 4, 5] =>
foldl (+) (0 + 1) [2, 3, 4, 5] =>
foldl (+) ((0 + 1) + 2) [3, 4, 5] =>
foldl (+) (((0 + 1) + 2) + 3) [4, 5] =>
... =>
((((0 + 1) + 2) + 3) + 4) + 5
~~~
