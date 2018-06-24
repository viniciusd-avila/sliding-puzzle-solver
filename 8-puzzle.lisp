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


(defun is-goal (board)
  (block why 
	(loop for i from 0 to (- (length board) 2)
		  do (if (not (equal (aref board i) (+ i 1)))
			   (return-from why nil))))
  t)

(defun solve (state-list n)
	;método sem uso de classe. ALTERAR
	;como determinar o estado atual com a classe state?
	(let ((board (list (make-array (list n n) :initial-contents state-list) 'inf 0)) ; <--
        (goal (def-goal n)))
	(setf (nth 1 board) (hamming (nth 1 board) goal n)) ; <--
       ...))
    
;defining hamming distance
(defun hamming-dist (board)
  (let ((n (length board))
		(hamm 0))
	(loop for i from 0 to (- n 1)
		do (if (and (not (equal (aref board i) (+ i 1))) (not (equal (aref board i) 0)))
			 (setf hamm (+ hamm 1))))
	hamm))

;defining manhattam distance
;podemos fazer em outro momento...
(defun manhattan-dist (board)
  ...)

;creating neighbors
(defun gen-neighbors (board)
  (let* ((n (sqrt (length board)))
		(zero-pos (position 0 board)))
	(if (> (- zero-pos n) 1) (swap-elements zero-pos (- zero-pos n)))
	(if (< (+ zero-pos n) (- (* n n) 1)) (swap-elements zero-pos (+ zero-pos n)))
	(if (not (zerop (mod zero-pos n))) (swap-elements zero-pos (- zero-pos 1)))
	(if (not (zerop (mod (+ zero-pos 1) n))) (swap-elements zero-pos (+ zero-pos 1)))))

;swap 0 with all the possibilities in board
(defun swap-elements (board zero-pos nbs-pos)
	;; make instance of object board
	;; make copy issue
  (setf 
	(aref board zero-pos) (aref board nbs-pos)
	(aref boad nbs-pos) 0))

;determine if board is solvable by the number of inversions in matrix
(defun is-solvable (board)
  (let ((n (length board))
		(inversions))
  (loop for i from 0 to (- n 1)
		do (if (not (zerop (aref board i))) 
			 (loop for j from 1 to (- n 1)
				 do (if (and (not (zerop (aref board j))) (> (aref board j) (aref board i))) 
					  (setf inversions (+ inversions 1))))))
  (zerop (mod inversions 2))))
      
;creating priority-queue
(defun priority-queue ()
...)
