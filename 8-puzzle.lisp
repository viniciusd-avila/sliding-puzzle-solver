;;https://common-lisp.net/project/cl-heap/
(ql:quickload :cl-heap)

(defclass board ()
	((state		:accessor board-state
			:initarg :state)
	 (father	:accessor board-father
			:initarg :father
			:initform nil)
	 (hamming	:accessor board-hamming
			:initarg :hamming
			:initform nil)
	 (moves		:accessor board-moves
			:initarg :moves
			:initform 0)
	 (zeropos	:accessor board-zeropos
			:initarg :zeropos
			:initform nil)))

(defparameter *game-tree* (make-instance 'cl-heap:priority-queue)) 

(defun is-goal (board)
  (block why 
	(loop for i from 0 to (- (length board) 2)
		  do (if (not (equal (aref board i) (+ i 1)))
			   (return-from why nil)))
                       t))

(defun unroll (board &optional res)
  (cond ((board-father board)
         (push (board-state board) res)
         (unroll (board-father board) res))
        (t res)))
                 
;defining hamming distance
(defun hamming-dist (board)
  (let ((n (length board))
		(hamm 0))
	(loop for i from 0 to (- n 1)
		do (if (and (not (equal (aref board i) (+ i 1))) (not (equal (aref board i) 0)))
			 (setf hamm (+ hamm 1))))
	hamm))

(defun make-move (board zero-pos nbs-pos)
  (let* ((n (length board))
         (child (make-array n)))
    (loop for i from 0 to (- n 1)
          do (cond 
              ((eq i nbs-pos) (setf (aref child i) 0))
              ((eq i zero-pos) (setf (aref child i) (aref board nbs-pos)))
              (t (setf (aref child i) (aref board i)))))
    child))

(defun enqueue-child (board zero-pos move)
	(let* ((child     (make-move board zero-pos move))
               (child-obj (make-instance 'board 
                                         :state child 
                                         :father board
                                         :hamming (hamming-dist child) 
                                         :moves (+ 1 (board-moves board))
                                         :zeropos (position 0 child))))
          (cl-heap:enqueue *game-tree* child-obj 
		(+ (board-hamming child-obj) (board-moves child-obj)))))

;creating neighbors
;swap 0 with all the possibilities in board
(defun gen-neighbors (obj)
  (let* ((board (board-state obj))
	 (n (sqrt (length board)))
	 (zero-pos (position 0 board)))
	(if (>=	(- zero-pos n) 0) 
	    (enqueue-child board zero-pos (- zero-pos n)))
	(if (< (+ zero-pos n) (* n n)) 
	    (enqueue-child board zero-pos (+ zero-pos n)))
	(if (not (zerop (mod zero-pos n))) 
	    (enqueue-child board zero-pos (- zero-pos 1)))
	(if (not (zerop (mod (+ zero-pos 1) n))) 
	    (enqueue-child board zero-pos (+ zero-pos 1)))))

;determine if board is solvable by the number of inversions in matrix
(defun is-solvable (board)
  (let ((n (length board))
	(inversions 0))
  (loop for i from 0 to (- n 1)
		do (if (not (zerop (aref board i))) 
			 (loop for j from (+ i 1) to (- n 1)
				 do (if (and (not (zerop (aref board j))) (> (aref board j) (aref board i)))
					  (setf inversions (+ inversions 1))))))
  (if (zerop (mod n 2))
      (multiple-value-bind (q r) (floor (position 0 board) n)
        (if (zerop r) 
            (zerop (mod (+  inversions (- q 1)) 2)) 
          (zerop (mod (+ inversions q) 2))))
    (zerop (mod inversions 2)))))

(defun solve-aux ()
  (let ((obj (cl-heap:dequeue *game-tree*)))
    (cond ((is-goal (board-state obj))
           (unroll obj))
          (t (gen-neighbors obj)
             (solve-aux)))))

(defun solve (board-list)
  (let ((board (make-instance 'board 
                              :state 'board-list 
                              :hamming (hamming-dist board-list)
                              :zeropos (position 0 board-list))))
    (cl-heap:enqueue *game-tree* 'board (board-hamming board))
    (if (is-solvable (board-state board))
        (let ((ans (solve-aux)))
          (list ans (length ans)))
      (print "Unsolvable"))))
