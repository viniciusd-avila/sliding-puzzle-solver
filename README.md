# Sliding Puzzle Solver

Common Lisp implementation of the [A\* search algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) to solve n-by-n sliding puzzles.

![8-puzzle example](https://github.com/viniciusd-avila/sliding-puzzle-solver/blob/master/8-puzzle-example.png)

Call `(solve '(0 1 3 4 2 5 7 8 6) #'manhattan-dist)` to get a list of moves to solve the puzzle. Manhattan-dist is a heuristic function, you can alternatevely use the less eficient *hamming-dist* passing it as the 2nd argument of the *solve* function.  
