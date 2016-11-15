% Intro to Haskell, day 6
% G Bordyugov
% Nov 2016


Today
=====

0. Types recap
1. Monads

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
type TreeOfIats = Tree Int
type ListOfListsOfChar = List (List Char)
~~~

Monad typeclass
===============
~~~{.haskell .ignore}
class Monad m where
  return :: a -> m a
  (>>=) :: m a -> (a -> m b) -> mb
  (>>) :: m a -> m b -> m b

~~~
