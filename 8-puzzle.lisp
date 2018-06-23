(defclass state ()
  ((actual :acessor state-actual
           :initarg :actual)
   (father :acessor state-father
           :initarg :father)
   (hamm   :acessor state-hamm
           :initarg :hamm
           :initform nil)
   (zero   :acessor state-zero
           :initarg :zero
           :initform nil)
   (nbs    :acessor state-nbs
           :initarg :nbs
           :initform nil)))

(defun solve (state-list n)
  ;método sem uso de classe. ALTERAR
  ;como determinar o estado atual com a classe state?
  (let ((actual-state (list (make-array (list n n) :initial-contents state-list) 'inf 0)) ; <--
        (goal (def-goal n)))
    (setf (nth 1 actual-state) (hamming (nth 1 actual-state) goal n)) ; <--
       ...))
    
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
(defun hamming (state goal n)
  (loop for i from 1 to n
        do (loop for j from 1 to n
                 do (let ((x (aref (state-actual) (1- i) (1- j))))
                         (if (not (equal x (aref goal (1- i) (1- j))))
                             (if (not (equal x 0))
                                 (setf (state-hamm) (1+ (state-hamm)))))))))

;defining manhattam distance
;podemos fazer em outro momento...
(defun manhattam (actual-state goal n)
  ...)

;creating neighbors
(defun neighbors (actual-state)
  ...)

;determine if we reached goal matrix
(defun isgoal (actual-state goal)
  (if (equalp actual-state goal)))

;find zero in matrix
;só precisamos fazer uma passada para o primeiro, basta alterar o state-zero quando realizarmos o swap
;não sei se é necessario
(defun find-zero (state n)
  (loop for i from 1 to n
        do (loop for j from 1 to n
                 do (cond ((equal (aref state-actual (1- i) (1- j)) 0)
                           (setf (state-zero) '(1- i) '(1-j)))))))

;swap 0 with all the possibilities in actual-state
(defun swap (actual-state i j)
  ...)

;determine if actual-state is solvable
(defun is-solvable (actual-state)
  ...)

;number of inversions in matrix
(defun inversions (actual-state goal n)
  ...)

;creating priority-queue
(defun priority-queue ()
  ...)


