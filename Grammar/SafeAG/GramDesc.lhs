A nicer syntax for writing the grammar description of a datatype.

> {-# LANGUAGE
>       MultiParamTypeClasses
>     , FunctionalDependencies
>     , FlexibleInstances
>  #-}

> module Grammar.SafeAG.GramDesc where
> import Grammar.SafeAG.Core
> import Data.Dynamic (Typeable)

> infixr 2 |=

Overloaded operator for associations.

> class Assoc t a b | a b -> t where
>   (|=) :: a -> b -> t

> instance (Typeable a, Typeable b) =>
>   Assoc (ChildDesc a) Child (a -> Maybe b) where
>   (|=) = childDesc

> instance (Typeable a, Typeable b) =>
>   Assoc (TermDesc a) (Attr T b) (a -> Maybe b) where
>   (|=) = termDesc

> instance (Typeable a) =>
>   Assoc (ProdDesc a) Production ([ChildDesc a], [TermDesc a]) where
>   p |= (cd, td) = prodDesc p cd td

> instance (Typeable a) =>
>   Assoc (NtDesc a) NonTerminal [ProdDesc a] where
>   (|=) = ntDesc

Pairs of ChildDesc and TermDesc.  This definition is useful
to guide the typechecker so that the good instance of Assoc
is chosen (for ProdDesc).
 
> infixr 8 &
> (&) :: [ChildDesc a] -> [TermDesc a] -> ([ChildDesc a], [TermDesc a])
> (&) = (,)

Grammar Alternatives. The operator `|||' is overloaded so
that the last NtDesc is automatically coerced to GramDesc in
a list of alternatives: x ||| y ||| z

> infixr 0 |||

> class GramAlt a t where
>   (|||) :: (Typeable a) =>
>     NtDesc a -> t -> GramDesc a

> instance (Typeable b) => GramAlt a (NtDesc b) where
>   x ||| y = x `insert_nt` gramDesc y

> instance GramAlt a (GramDesc b) where
>   (|||) = insert_nt

Local Variables:
mode: org
eval: (org-indent-mode -1)
eval: (mmm-ify-by-class 'literate-haskell-bird)
eval: (local-set-key (kbd "<XF86MonBrightnessDown>") 'mmm-parse-buffer)
compile-command: "cd ../..; ghc Grammar/SafeAG/GramDesc.lhs"
End:
