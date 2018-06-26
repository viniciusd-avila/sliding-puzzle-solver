;;https://common-lisp.net/project/cl-heap/
(ql:quickload :cl-heap)

(defclass board ()
  ((state	:accessor board-state
		:initarg :state)
   (father	:accessor board-father
		:initarg :father
		:initform nil)
   (hamming	:accessor board-hamming
		:initarg :hamming
		:initform nil)
   (moves	:accessor board-moves
		:initarg :moves
		:initform 0)
   (zeropos	:accessor board-zeropos
		:initarg :zeropos
		:initform nil)))

(defun is-goal (board-array)
  (block why 
    (loop for i from 0 to (- (length board-array) 2)
          do (if (not (equal (aref board-array i) (+ i 1)))
                 (return-from why nil)))
    t))

(defun unroll (board-obj &optional res)
  (cond ((board-father board-obj)
         (push (board-state board-obj) res)
         (unroll (board-father board-obj) res))
        (t res)))
                 
(defun hamming-dist (board-array)
  (let ((n (length board-array))
        (hamm 0))
    (loop for i from 0 to (- n 1)
          do (if (and 
                  (not (equal (aref board-array i) (+ i 1))) (not (equal (aref board-array i) 0)))
                 (setf hamm (+ hamm 1))))
    hamm))

(defun make-move (board-obj zero-pos nbs-pos)
  (let* ((parent-array (board-state board-obj))
		(n (length parent-array))
        (child-array (make-array n)))
    (loop for i from 0 to (- n 1)
          do (cond 
              ((eq i nbs-pos) (setf (aref child-array i) 0))
              ((eq i zero-pos) (setf (aref child-array i) (aref parent-array nbs-pos)))
              (t (setf (aref child-array i) (aref parent-array i)))))
    child-array))

(defun is-granparent (parent-obj child-obj)
  (and (board-father parent-obj) (equalp (board-state child-obj) (board-state (board-father parent-obj)))))
  
(defun enqueue-child (queue board-obj zero-pos move)
  (let* ((child-array (make-move board-obj zero-pos move))
         (child-obj (make-instance 'board 
                                   :state child-array 
                                   :father board-obj
                                   :hamming (hamming-dist child-array) 
                                   :moves (+ 1 (board-moves board-obj))
                                   :zeropos (position 0 child-array))))
    (if (not (is-granparent board-obj child-obj))
            (cl-heap:enqueue queue child-obj (+ (board-hamming child-obj) (board-moves child-obj))))))

(defun gen-neighbors (board-obj queue)
  (let* ((n (truncate (sqrt (length (board-state board-obj)))))
		(zero-pos (position 0 (board-state board-obj))))
	(if (>=	(- zero-pos n) 0)
	    (enqueue-child queue board-obj zero-pos (- zero-pos n)))
	(if (< (+ zero-pos n) (* n n)) 
	    (enqueue-child queue board-obj zero-pos (+ zero-pos n)))
	(if (not (zerop (mod zero-pos n))) 
	    (enqueue-child queue board-obj zero-pos (- zero-pos 1)))
	(if (not (zerop (mod (+ zero-pos 1) n))) 
	    (enqueue-child queue board-obj zero-pos (+ zero-pos 1)))))

(defun is-solvable (board-array)
  (let ((n (length board-array))
	(inversions 0))
  (loop for i from 0 to (- n 1)
	do (if (not (zerop (aref board-array i))) 
               (loop for j from (+ i 1) to (- n 1)
                     do (if (and 
                             (not (zerop (aref board-array j))) (> (aref board-array j) (aref board-array i)))
                            (setf inversions (+ inversions 1))))))
  (if (zerop (mod n 2))
      (multiple-value-bind (q r) (floor (position 0 board-array) n)
        (if (zerop r) 
            (zerop (mod (+  inversions (- q 1)) 2)) 
          (zerop (mod (+ inversions q) 2))))
    (zerop (mod inversions 2)))))

(defun solve-aux (queue)
  (let ((board-obj (cl-heap:dequeue queue)))
    (cond ((is-goal (board-state board-obj))
           (unroll board-obj))
          (t (gen-neighbors board-obj queue)
             (solve-aux queue)))))

(defun solve (board-array)
  (let ((board-obj (make-instance 'board 
                              :state board-array
                              :hamming (hamming-dist board-array)
                              :zeropos (position 0 board-array)))
        (game-tree (make-instance 'cl-heap:priority-queue)))
    (cl-heap:enqueue game-tree board-obj (board-hamming board-obj))
    (if (is-solvable (board-state board-obj))
        (let ((ans (solve-aux game-tree)))
          (list ans (length ans)))
      (print "Unsolvable"))))
