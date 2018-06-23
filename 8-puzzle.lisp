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
(defun hamming (board goal n)
	(loop for i from 1 to n
		do (loop for j from 1 to n
			do (let ((x (aref (board-state) (1- i) (1- j))))
				 (if (not (equal x (aref goal (1- i) (1- j))))
				   (if (not (equal x 0))
					 (setf (board-hamming) (1+ (board-hamming)))))))))

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
;starting this function
(defun is-solvable (board goal n)
  (let ((rest (multiple-value-bind (q r) (floor n 2) r))
        (inv (multiple-value-bind (q r) (floor (inversion board goal n) 2))))
    (cond ((and (equal rest 1) (equal inv 0)) t
           (...)))))

;number of inversions in matrix
;error in result, dont know why
(defun inversion (board goal n)
  (let ((inv-list))
    (loop for i from 1 to n
          do (loop for j from 1 to n
                   do (let ((board-v (aref board (1- i) (1- j)))
                            (goal-v  (aref goal (1- i) (1- j))))
                        (cond ((and (not (equal board-v goal-v)) 
                                    (not (equal board-v 0)) 
                                    (not (equal goal-v 0)))
                               (setf inv-list (append (list (cons (min board-v goal-v)
                                                                  (max board-v goal-v))) inv-list)))))))
    (remove-duplicates inv-list :test #'equal)
    (length inv-list)))

;creating priority-queue
(defun priority-queue ()
  ...)


