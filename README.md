# dldist

dldist is a command line utility that returns the
[Damerau-Levenshtein distance](https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance "Wiki article")



The distance from 'citten' to 'kitten':

    $ dldist -from citten -to kitten
    1: [citten]  'kitten'


The program also accepts a dictionary file.

    $ dldist -dictionary ~/Documents/en.txt -from   citten
    1: [citten]  'bitten' 'cittern' 'kitten' 'litten' 'mitten' 'pitten' 'sitten' 'yitten'


To check multiple words at once we can use the -list parameter..

    $ dldist -dictionary ~/Documents/en.txt -list ~/Documents/file.txt
    0: [mug] 'mug'
    ...
