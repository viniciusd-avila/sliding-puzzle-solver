(defun solve (state-list n)
  (let ((actual-state (list (make-array (list n n) :initial-contents state-list) 'inf 0))
        (goal (def-goal n)))
    (setf (nth 1 actual-state) (hamming (nth 1 actual-state) goal n))))
    
;creating goal matrix nxn    
(defun def-goal (n)
  (let ((goal (make-array (list n n))))
    (loop for i from 1 to n
          do (loop for j from 1 to n
                   do (cond ((equal (+ (1+ (* n (1- i))) (1- j)) (* n n)) 
                             (setf (aref goal (1- i) (1- j)) 0))
                            (t (setf (aref goal (1- i) (1- j)) (+ (1+ (* n (1- i))) (1- j)))))))
    goal))

;defining hamming distance
(defun hamming (actual-state goal n)
  (let ((ham 0))
    (loop for i from 1 to n
          do (loop for j from 1 to n
                   do (let ((x (aref actual-state (1- i) (1- j))))
                        (if (not (equal x (aref goal (1- i) (1- j))))
                            (if (not (equal x 0))
                                (setf ham (1+ ham)))))))
    ham))

;defining manhattam distance
(defun manhattam (actual-state goal n))

;creating neighbors
(defun neighbors (actual-state))

;determine if we reached goal matrix
(defun isgoal (actual-state goal)
  (if (equalp actual-state goal)))

;defining swap 0 with a number
(defun swap (actual-state i j))

;determine if actual-state is solvable
(defun is-solvable (actual-state))

;number of inversions in matrix
(defun inversions (actual-state goal n))

;creating priority-queue
(defun priority-queue ...)


