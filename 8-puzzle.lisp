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
    
;defining hamming distance
(defun hamming-dist (board)
  (let ((n (array-dimension board 0))
		(hamm 0))
	(loop for i from 0 to (- n 1)
		do (if (and (not (equal (aref board i) i)) (not (equal (aref board i) 0)))
			 (setf hamm (+ hamm 1))))
	hamm))

;defining manhattam distance
;podemos fazer em outro momento...
(defun manhattan-dist (board)
  ...)

;creating neighbors
(defun gen-neighbors (board)
  ...)

;swap 0 with all the possibilities in board
(defun swap-elements (board zeropos nbspos)
  (setf 
	(aref board zeropos) (aref board nbspos)
	(aref boad nbspos) 0))

;determine if board is solvable by the number of inversions in matrix
(defun is-solvable (board)
  (let ((n (array-dimension board 0))
		(inversions))
  (loop for i from 0 to (- n 1)
		do (loop for j from 1 to (- n 1)
				 do (if (> (aref board j) (aref board i)) 
					  (setf inversions (+ inversions 1)))))
  (zerop (mod inversions 2))))
      
;creating priority-queue
(defun priority-queue ()
...)
