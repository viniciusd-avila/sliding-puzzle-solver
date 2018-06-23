(defclass board ()
	((actual	:accessor board-state
				:initarg :state)
	 (father	:accessor board-parent
				:initarg :parent)
	 (hamming	:accessor board-hamming
				:initarg :hamming
				:initform nil)
	 (manhattan	:accessor board-manhattan
				:initform nil)
	 (zeropos	:accessor board-zeropos
				:initform nil)))

(defun solve (state-list n)
	;método sem uso de classe. ALTERAR
	;como determinar o estado atual com a classe state?
	(let ((board (list (make-array (list n n) :initial-contents state-list) 'inf 0)) ; <--
        (goal (def-goal n)))
	(setf (nth 1 board) (hamming (nth 1 board) goal n)) ; <--
       ...))
    
;; creating goal matrix nxn 
(defun gen-goal (n)
  (let ((goal-board (make-array (list n n)))
		(counter 1))
  (loop for line from  0 to (- n 1)
	do (loop for column from 0 to (- n 1)
		  do (if (equal counter (* n n)) 
			   (setf (aref goal-board line column) 0)
			   (setf (aref goal-board line column) counter counter (+ 1 counter)))))
  	goal-board))

;defining hamming distance
(defun hamming (state goal n)
	(loop for i from 1 to n
		do (loop for j from 1 to n
			do (let ((x (aref (state-actual) (1- i) (1- j))))
				 (if (not (equal x (aref goal (1- i) (1- j))))
				   (if (not (equal x 0))
					 (setf (state-hamm) (1+ (state-hamm)))))))))

;defining manhattam distance
;podemos fazer em outro momento...
(defun manhattam (board goal n)
  ...)

;creating neighbors
(defun neighbors (board)
  ...)

;determine if we reached goal matrix
(defun isgoal (board goal)
  (if (equalp board goal)))

;find zero in matrix
;só precisamos fazer uma passada para o primeiro, basta alterar o state-zero quando realizarmos o swap
;não sei se é necessario
(defun find-position (board element)
  (let ((n (array-dimension board 0)))
	(block why
		(loop for i from 0 to (- n 1)
			do (loop for j from 1 to (- n 1) 
				do (if (equal (aref board i j) element) 
					 (return-from why (list i j))))))))

;swap 0 with all the possibilities in board
(defun swap (board i j)
  ...)

;determine if board is solvable
(defun is-solvable (board)
  ...)

;number of inversions in matrix
(defun inversions (board goal n)
  ...)

;creating priority-queue
(defun priority-queue ()
  ...)


