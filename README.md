# dldist

dldist is a command line utility that returns the
[Damerau-Levenshtein distance](https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance "Wiki article")



The distance from 'kitten' to 'sitting':

    $ dldist -from kitten -to sitting
    3

The distance from 'hte' to 'the':

    $ dldist -from hte -to the
    1

The program also accepts a dictionary file.

    $ dldist -dictionary ~/Documents/en.txt citten
    1: [citten] 'bitten' 'cittern' 'kitten' 'litten' 'mitten' 'pitten' 'sitten' 'yitten'

To check multiple words at once we can use the -list parameter..

    $ dldist -dictionary ~/Documents/en.txt -list ~/Documents/file.txt
    0: [mug] 'mug'
