#!/usr/bin/clisp

(defun PrintExercise
   (heading &optional code output prints?)
   (format t "~A:~%" heading)
   (unless code (return-from PrintExercise (format t "TBD~%~%")))
   (format t "~A~%" code)
   (format t "actual:   ")
   (if prints?
      (eval code)
      (format t "~A" (eval code))
   )
   (terpri)
   (if output (format t "expected: ~A~%" output))
   (terpri)
)

; 2.8a

(defun rdots
   (x)
   (if
      (> x 0)
      (or
         (format t ".")
         (rdots (- x 1))
      )
   )
)

(PrintExercise
   "Exercise 2.8a - recursive"
   '(rdots 5)
   "....."
   t
)

(defun idots
   (x)
   (do
      ((i 1 (+ i 1)))
      ((> i x) 'done)
      (format t ".")
   )
)

(PrintExercise
   "Exercise 2.8a - iterative"
   '(idots 5)
   "....."
   t
)

; 2.8b

(defun rcount
   (x y)
   (unless x (return-from rcount 0))
   (+
      (if (eql y (car x)) 1 0)
      (rcount (cdr x) y)
   )
)

(PrintExercise
   "Exercise 2.8b - recursive"
   '(rcount '(a b c d e a b c a) 'a)
   3
)

(defun icount
   (x y)
   (let
      (  (n 0))
      (do
         ((z x (cdr z)))
         ((null z) 'done)
         (if
            (eql y (car z))
            (setf n (+ n 1))
         )
      )
      n
   )
)

(PrintExercise
   "Exercise 2.8b - iterative"
   '(rcount '(a b c d e a b c a) 'a)
   3
)
