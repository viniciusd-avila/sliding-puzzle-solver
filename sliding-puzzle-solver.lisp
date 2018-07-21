;;https://common-lisp.net/project/cl-heap/
(ql:quickload :cl-heap)

(defclass board ()
  ((state	:accessor board-state
		:initarg :state)
   (father	:accessor board-father
		:initarg :father
		:initform nil)
   (distance	:accessor board-distance
		:initarg :distance
		:initform nil)
   (movecount	:accessor board-movecount
		:initarg :movecount
		:initform 0)
   (piece	:accessor board-piece
                :initarg :piece
                :initform nil) 
   (zeropos	:accessor board-zeropos
		:initarg :zeropos
		:initform nil)))

(defun is-goal (board-array)
  (block why 
    (loop for i from 0 to (- (length board-array) 2)
          do (if (not (equal (aref board-array i) (+ i 1)))
                 (return-from why nil)))
    t))

(defun unroll (game-tree board-obj &optional mov res) 
  (cond ((board-father board-obj)
         (push (board-piece board-obj) mov)
         (push (board-state board-obj) res)
         (unroll game-tree (board-father board-obj) mov res))
        (t (list res mov (cl-heap:queue-size game-tree)))))
                 
(defun hamming-dist (board-array)
  (let ((n (length board-array))
        (hamm 0))
    (loop for i from 0 to (- n 1)
          do (if (and (not (equal (aref board-array i) (+ i 1))) (not (equal (aref board-array i) 0)))
                 (setf hamm (+ hamm 1))))
    hamm))

(defun manhattan-dist (board-array)
  (let* ((n (length board-array))
         (m (truncate (sqrt n)))
         (manh 0))
    (loop for i from 0 to (- n 1)
          do (let ((val (aref board-array i)))
               (if (and (not (equal val (+ i 1))) (not (equal val 0)))
                   (setf manh (+ manh (+ (abs (- (mod i m) (mod (- val 1) m)))
                                         (abs (- (truncate (/ i m)) (truncate (/ (- val 1) m))))))))))
          manh))

(defun make-move (board-obj move)
  (let* ((parent-array (board-state board-obj))
         (n (length parent-array))
         (child-array (make-array n)))
    (loop for i from 0 to (- n 1)
          do (cond ((eq i move) (setf (aref child-array i) 0))
                   ((eq i (board-zeropos board-obj)) (setf (aref child-array i) (aref parent-array move)))
                   (t (setf (aref child-array i) (aref parent-array i)))))
    child-array))

(defun is-granparent (parent-obj child-array)
  (and (board-father parent-obj) (equalp child-array (board-state (board-father parent-obj)))))
  
(defun enqueue-child (game-tree board-obj move function)
  (let* ((child-array (make-move board-obj move)))
	(if (not (is-granparent board-obj child-array))
		(let
         ((child-obj (make-instance 'board 
                                   :state child-array 
                                   :father board-obj
                                   :distance (funcall function child-array) 
                                   :movecount (+ 1 (board-movecount board-obj))
                                   :piece (aref (board-state board-obj) move)
                                   :zeropos move)))
        (cl-heap:enqueue game-tree child-obj (+ (board-distance child-obj) (board-movecount child-obj)))))))

(defun gen-children (board-obj game-tree function)
  (let* ((n (truncate (sqrt (length (board-state board-obj)))))
		(zero (board-zeropos board-obj)))
    (if (>= (- zero n) 0)
        (enqueue-child game-tree board-obj(- zero n) function))
    (if (< (+ zero n) (* n n)) 
        (enqueue-child game-tree board-obj (+ zero n) function))
    (if (not (zerop (mod zero n))) 
        (enqueue-child game-tree board-obj (- zero 1) function))
    (if (not (zerop (mod (+ zero 1) n))) 
        (enqueue-child game-tree board-obj (+ zero 1) function))))

(defun is-solvable (board-array)
  (let ((n (length board-array))
	(inversions 0))
    (loop for i from 0 to (- n 1)
          do (if (not (zerop (aref board-array i))) 
                 (loop for j from (+ i 1) to (- n 1)
                       do (if (and (not (zerop (aref board-array j))) (> (aref board-array j) (aref board-array i)))
                              (setf inversions (+ inversions 1))))))
    (if (zerop (mod n 2))
        (let ((q (floor (position 0 board-array) (truncate (sqrt n)))))
          (zerop (mod (+ inversions q) 2)))
      (zerop (mod inversions 2)))))

(defun solve-aux (game-tree function)
  (let ((board-obj (cl-heap:dequeue game-tree)))
    (cond ((is-goal (board-state board-obj))
           (unroll game-tree  board-obj))
          (t (gen-children board-obj game-tree function)
             (solve-aux game-tree function)))))

(defun rec-ans (ans &optional (len (length (car ans))))
  (cond ((null (car ans)) (format t "~%~%Number of moves: ~%~D~%~%Move order:~% ~%~D~%~%Queue size:~%~D~% " len (cadr ans) (caddr ans)))
        (t (print (caar ans))
           (rec-ans (cons (cdr (car ans)) (cdr ans)) len))))

(defun solve (board-list function)
  (let* ((board-array (make-array (length board-list) :initial-contents board-list))
         (board-obj (make-instance 'board 
                                   :state board-array
                                   :distance (funcall function board-array)
                                   :zeropos (position 0 board-array)))
         (game-tree (make-instance 'cl-heap:priority-queue)))
    (cl-heap:enqueue game-tree board-obj (board-distance board-obj))
    (if (is-solvable (board-state board-obj))
        (let ((ans (solve-aux game-tree function)))
	  (rec-ans ans))
	 (print "Unsolvable"))))
