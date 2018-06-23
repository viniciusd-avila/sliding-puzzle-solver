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
  (let ((goal-board (make-array (list n n))))
  (loop for line from  0 to (- n 1)
	do (loop for col from 0 to (- n 1)
		  do (if (equal (+ (* n line) (+ col 1)) (* n n)) 
			   (setf (aref goal-board line col) 0)
			   (setf (aref goal-board line col) (+ (* n line) (+ col 1))))))
  	goal-board))

;defining hamming distance
(defun hamming-dist (board)
  (let ((n (array-dimension board 0))
		(hamm 0))
	(loop for i from 0 to (- n 1)
		do (loop for j from 0 to (- n 1)
			do (if (not (equal (aref board i j) (+ (* n i) (+ j 1))))
				   (if (not (equal (aref board i j) 0))
					 (setf hamm (+ hamm 1))))))
	hamm))

;defining manhattam distance
;podemos fazer em outro momento...
(defun manhattan-dist (board)
  ...)

;creating neighbors
(defun gen-neighbors (board)
  ...)

;; find element position in matrix
(defun find-position (board element)
  (let ((n (array-dimension board 0)))
	(block why
	(loop for i from 0 to (- n 1)
		do (loop for j from 1 to (- n 1) 
			do (if (equal (aref board i j) element) 
				 (return-from why (list i j))))))))

;swap 0 with all the possibilities in board
(defun swap-elements (board zeropos nbspos)
  (setf 
	(aref board (car zeropos) (cdr zeropos)) (aref board (car nbspos) (cdr nbspos))
	(aref boad (car nbspos) (cdr nbspos)) 0))

;linearizando a matriz
(defun linear-matrix (board n)
  (let ((board-list))
    (loop for i from 1 to n
          do (loop for j from 1 to n
                   do (cond ((not (equal (aref board (1- i) (1- j)) 0))
                             (push (aref board (1- i) (1- j)) board-list)))))
    (reverse board-list)))

;determine if board is solvable
;starting this function
(defun is-solvable (board goal n)
  (let ((rest (multiple-value-bind (q r) (floor n 2) r))
        (inv (multiple-value-bind (q r) (floor (inversion board goal n) 2))))
    (cond ((and (equal rest 1) (equal inv 0)) t
           (...)))))

;number of inversions in matrix
;wrong
(defun inversion (board goal n)
  (let ((inv-list))
    (loop for i from 1 to n
          do (loop for j from 1 to n
                   do (let ((board-v (aref board (1- i) (1- j)))
                            (goal-v  (aref goal (1- i) (1- j))))
                        (cond ((and (not (equal board-v goal-v)) 
                                    (not (equal board-v 0)) 
                                    (not (equal goal-v 0)))
                               (push (cons (min board-v goal-v) (max board-v goal-v)) inv-list))))))
    (setf inv-list (remove-duplicates inv-list :test #'equal))
    (length inv-list)))

;creating priority-queue
(defun priority-queue ()
...)
