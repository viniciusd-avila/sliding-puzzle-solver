;;testes para puzzles nxn

;;puzzles 2x2

;;solvable

(solve '(1 2 3 0) #'hamming-dist)
(solve '(1 2 0 3) #'manhattan-dist)
(solve '(2 3 1 0) #'hamming-dist)
(solve '(0 3 2 1) #'manhattan-dist)

;unsolvable

(solve '(1 0 2 3) #'hamming-dist)
(solve '(0 1 2 3) #'manhattan-dist)
(solve '(3 2 1 0) #'hamming-dist)


;;puzzles 3x3

;;solvable

(solve '(1 2 3 4 5 6 7 8 0) #'hamming-dist)
(solve '(1 2 3 4 5 6 7 0 8) #'manhattan-dist)
(solve '(0 1 2 4 5 3 7 8 6) #'manhattan-dist)
(solve '(0 4 3 2 1 6 7 5 8) #'manhattan-dist)
(solve '(1 3 5 7 2 6 8 0 4) #'manhattan-dist)
(solve '(7 4 3 2 8 6 0 5 1) #'manhattan-dist)
(solve '(5 3 6 4 0 7 1 8 2) #'manhattan-dist)
(solve '(6 5 3 4 1 7 0 2 8) #'manhattan-dist)
(solve '(8 6 7 2 0 4 3 5 1) #'manhattan-dist)

;;unsolvable

(solve '(1 2 3 4 6 5 7 8 0) #'hamming-dist)
(solve '(1 2 3 4 5 6 8 7 0) #'hamming-dist)
(solve '(8 6 7 2 5 4 1 3 0) #'manhattan-dist)


;;puzzles 4x4

;solvable

(solve '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0) #'manhattan-dist)
(solve '(1 2 3 4 5 6 7 8 9 0 10 11 13 14 15 12) #'manhattan-dist)
(solve '(5 1 3 4 9 2 7 8 13 0 10 12 14 6 11 15) #'manhattan-dist)
(solve '(2 5 3 4 1 7 11 8 9 6 0 12 13 14 15 10) #'manhattan-dist)

;unsolvable

(solve '(3 2 4 8 1 6 0 12 5 10 7 11 9 13 14 15) #'manhattan-dist)


;;puzzle 9x9

(solve '(1  2  3  4  5  6  7  8  9 
         10 11 12 13 14 15 16 17 18 
         19 20 21 22 23 24 25 26 27 
         28 29 30 31 32 33 34 35 36 
         37 38 39 40 41 42 43 44 45 
         46 47 48 49 50 51 52 53 54 
         55 56 57 58 59 60 61 62 63 
         64 65 66 67 68 69 70  0 71 
         73 74 75 76 77 78 79 80 72) #'manhattan-dist)


;puzzle 10x10

(solve '(1  2  3  4  5  6  7  8  9  10 
         11 12 13 14 15 16 17 18 19 20 
         21 22 23 24 25 26 27 28 29 30 
         31 32 33 34 35 36 37 38 39 40 
         41 42 43 44 45 46 47 48 49 50 
         51 52 53 54 55 56 57 58 59 60 
         61 62 63 64 65 66 67 68 69 70 
         71 72 73 74 75 76 77 78 79 80 
         81 82 83 84 85 86 87 88 89 90 
         91 92 93 94 95 96 97 98 99  0) #'manhattan-dist)
