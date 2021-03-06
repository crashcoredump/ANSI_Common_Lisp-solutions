#!/usr/bin/clisp

; I cheated here and used "let*" and "return-from" before they were introduced.

(load "util.lisp")

; 3.1

; See the accompanying image file(s) for the diagrames called-for by Exercise
; 3.1; the "cons" statements below are intended to aid in making those
; diagrams.

(PrintExercise
   "Exercise 3.1a"
   '(cons 'a (cons 'b (cons (cons 'c (cons 'd nil)) nil)))
   '(a b (c d))
)

(PrintExercise
   "Exercise 3.1b"
   '(cons 'a (cons (cons 'b (cons (cons 'c (cons (cons 'd nil) nil)) nil)) nil))
   '(a (b (c (d))))
)

(PrintExercise
   "Exercise 3.1c"
   '(cons
       (cons
          (cons 'a (cons 'b nil))
          (cons 'c nil)
       )
       (cons 'd nil)
    )
   '(((a b) c) d)
)

(PrintExercise
   "Exercise 3.1d"
   '(cons 'a (cons (cons 'b 'c) 'd))
   '(a (b . c) . d)
)

; 3.2

(defun new-union
   (x y)
   (unless y (return-from new-union x))
   (let
      (  (v (car y))
         (w (cdr y))
      )
      (new-union
         (if
            (member v x)
            x
            (append x (list v))
         )
         w
      )
   )
)

(PrintExercise
   "Exercise 3.2"
   '(new-union '(a b c) '(b a d))
   '(a b c d)
)

; 3.3

(defun occurrences
   (x)
   (unless x (return-from occurrences))
   (let*
      (  (u (car x))
         (v (reverse (occurrences (cdr x))))
         (w (assoc u v))
      )
      (unless w (return-from occurrences (cons (cons u 1) v)))
      (cons
         (cons
            (car w)
            (+ 1 (cdr w))
         )
         (remove w v)
      )
   )
)

(PrintExercise
   "Exercise 3.3"
   '(occurrences '(a b a d a c d c a))
   '((a . 4) (c . 2) (d . 2) (b . 1))
)

; 3.4

; This returns "nil" because "(a)" refers to two different lists - the lists
; are distinct, even though they have the same elements and appear identical.

(PrintExercise
   "Exercise 3.4"
   '(member '(a) '((a) (b)))
   "NIL"
)

; 3.5a

; this first solution is based on one I found while looking on the Internet for
; a solution, to see how well I solved the exercise - I thought this one was
; more elegant than mine, so I adapted it to my style;

(defun rpos++
   (x)
   (rposn++ x 0)
)

(defun rposn++
   (x n)
   (if
      (null x)
      (return-from rposn++)
   )
   (cons
      (+ (car x) n)
      (rposn++
         (cdr x)
         (+ n 1)
      )
   )  
)  

(PrintExercise
   "Exercise 3.5a (not my solution)"
   '(rpos++ '(7 5 1 4))
   '(7 6 3 7)
)

(defun rpos+
   (x)
   (let
      (  (n (length x)))
      (rposn+ x n n)
   )
)

(defun rposn+
   (x n m)
   (unless x (return-from rposn+))
   (cons
      (+
         (car x)
         (- m n)
      )
      (rposn+
         (cdr x)
         (- n 1)
         m
      )
   )
)

(PrintExercise
   "Exercise 3.5a (my solution)"
   '(rpos+ '(7 5 1 4))
   '(7 6 3 7)
)

; 3.5b

(defun ipos+
   (x)
   (let 
      (  (n 0)
         (y nil)
      )
      (dolist
         (w x)
         (push (+ w n) y)
         (setf n (+ n 1))
      )
      (reverse y)
   )
)

(PrintExercise
   "Exercise 3.5b"
   '(ipos+ '(7 5 1 4))
   '(7 6 3 7)
)

; 3.5c

(defun mpos+
   (x)
   (let
      (  (n -1))
      (mapcar
         (lambda
            (y)
            (setf n (+ n 1))
            (+ y n)
         )
         x
      )
   )
)

(PrintExercise
   "Exercise 3.5c"
   '(mpos+ '(7 5 1 4))
   '(7 6 3 7)
)

; 3.5 "extra credit" - by recursion + mapcar

(defun rmpos+
   (x)
   (unless x (return-from rmpos+))
   (cons
      (car x)
      (mapcar
         (lambda
            (y)
            (+ y 1)
         )
         (rmpos+ (cdr x))
      )
   )
)

(PrintExercise
   "Exercise 3.5 \"extra credit\""
   '(rmpos+ '(7 5 1 4))
   '(7 6 3 7)
)

; 3.6a

(defun gov_cons
   (x y)
   (cons y x)
)

(PrintExercise
   "Exercise 3.6a"
   '(gov_cons 'a 'b)
   '(b . a)
)

; 3.6b

; note that this is defined the same way "list" would be, with the exception of
; the usage of "gov_cons"; it would probably be more appopriate to swap the
; "head" and "tail" names, considering the intent of the exercise;

(defun gov_list
   (&rest args)
   (let
      (  (head (car args))
         (tail (cdr args))
      )
      (unless tail (return-from gov_list (gov_cons head nil)))
      (gov_cons head (apply (function gov_list) tail))
   )
)

(PrintExercise
   "Exercise 3.6b"
   '(gov_list 'a 'b 'c)
   '(((nil . c) . b) . a)
)

; 3.6c

(defun gov_length
   (x)
   (unless x (return-from gov_length 0))
   (+ 1 (gov_length (car x)))
)

(PrintExercise
   "Exercise 3.6c"
   '(gov_length (gov_list 'a 'b 'c))
   3
)

; 3.6d

(defun gov_member
   (x y)
   (unless y (return-from gov_member))
   (if
      (eql x (cdr y))
      y
      (gov_member x (car y))
   )
)

(PrintExercise
   "Exercise 3.6d"
   '(gov_member 'b (gov_list 'a 'b 'c))
   (gov_list 'b 'c)
)

; 3.7

(defun compress
   (x)
   (unless
      (consp x)
      (return-from compress x)
   )
   (compr
      (car x)
      1
      (cdr x)
   )
)

(defun compr
   (elt n lst)
   (unless lst (return-from compr (list (n-elts elt n))))
   (let
      (  (next (car lst)))
      (if
         (eql next elt)
         (compr elt
            (+ n 1)
            (cdr lst)
         )
         (cons
            (n-elts elt n)
            (compr next 1 (cdr lst))
         )
      )
   )
)

(defun n-elts
   (elt n)
   (if
      (> n 1)
      (cons n elt)
      elt
   )
)

(defun uncompress
   (lst)
   (unless lst (return-from uncompress))
   (let
      (  (elt (car lst))
         (rest (uncompress (cdr lst)))
      )
      (if
         (consp elt)
         (append (apply (function list-of) elt) rest)
         (cons elt rest)
      )
   )
)

(defun list-of
   (n elt)
   (unless
      (zerop n)
      (cons elt (list-of (- n 1) elt))
   )
)

(PrintExercise
   "Exercise 3.7 - n-elts"
   '(n-elts 'x 5)
   '(5 . x)
)

(PrintExercise
   "Exercise 3.7 - compress"
   '(compress '(1 1 1 0 1 0 0 0 0 1))
   '((3 . 1) 0 1 (4 . 0) 1)
)

(PrintExercise
   "Exercise 3.7 - list-of"
   '(list-of 3 'ho)
   '(ho ho ho)
)

(PrintExercise
   "Exercise 3.7 - uncompress"
   '(uncompress '((3 1) 0 1 (4 0) 1))
   '(1 1 1 0 1 0 0 0 0 1)
)

; 3.8
;
; Define a function that takes a list and prints it in dot notation:

(defun showdots
   (x)
   (unless x (return-from showdots))
   (format nil "(~A . ~A)"
      (car x)
      (showdots (cdr x))
   )
)

(PrintExercise
   "Exercise 3.8 - my solution"
   '(showdots '(a b c))
   "(A . (B . (C . NIL)))"
)

(defun showdots
   (x)
   (if
      (atom x)
      (return-from showdots (format nil "~A" x))
   )
   (format nil "(~A . ~A)"
      (showdots (car x))
      (showdots (cdr x))
   )
)

(PrintExercise
   "Exercise 3.8 - not my solution"
   '(showdots '(a b c))
   "(A . (B . (C . NIL)))"
)

; 3.9

; Prior to the exercise solution, I've reproduced here for reference the code
; (with modification) for finding the *shortest* path:

(defun shortest-path
   (start end net)
   (bfs end (list (list start)) net)
)

(defun new-paths
   (path node net)
   (mapcar 
      (lambda
         (n)
         (cons n path)
      )
      (cdr (assoc node net))
   )
)

; BFS = breadth-first search

(defun bfs
   (end queue net)
   (unless queue (return-from bfs))
   (let*
      (  (path (car queue))
         (node (car path))
      )
      (if
         (eql node end)
         (return-from bfs (reverse path))
      )
      (bfs
         end
         (append
            (cdr queue)
            (new-paths path node net)
         )
         net
      )
   )
)

(defun longest-path
   (start end net)
   (dfs end (list (list start)) net)
)

; DFS = depth-first search

(defun dfs
   (end queue net)
   (unless queue (return-from dfs))
   (let*
      (
         (path (car queue))
         (node (car path))
      )
      (if
         (eql node end)
         (return-from dfs (reverse path))
      )
      (dfs
         end
         (append
            (new-paths path node net)
            (cdr queue)
         )
         net
      )
   )
)

(PrintExercise
   "shortest path (chapter example)"
   '(shortest-path 'a 'd '((a b c) (b c) (c d)))
   '(a c d)
)

(PrintExercise
   "Exercise 3.9 - longest path"
   '(longest-path 'a 'd '((a b c) (b c) (c d)))
   '(a b c d)
)

; The following alternate version of "longest-path" was found somewhere on the
; Internet.  I've modified it somewhat, but I need to continue modifying it so
; that it isn't completely unreadable.

(defun longest-path
   (start end net)
   (if
      (eql start end)
      (return-from longest-path (list start))
   )
   (let
      (  (neigh (assoc start net)))
      (labels
         (  (func1
               (entry)
               (cons
                  (car entry)
                  (remove start (cdr entry))
               )
            )
            (func2
               (temp)
               (if temp (cons start temp))
            )
            (func3
               (lst)
               (unless lst (return-from func3))
               (let
                  (  (obj (car lst))
                     (lsf (func3 (cdr lst)))
                  )
                  (if
                     (>
                        (length obj)
                        (length lsf)
                     )
                     obj
                     lsf
                  )
               )
            )
            (func4
               (node)
               (longest-path node end (mapcar #'func1 (remove neigh net)))
            )
         )
         (funcall
            (function func2)
            (funcall
               (function func3)
               (mapcar
                  (function func4)
                  (cdr neigh)
               )
            )
         )
      )
   )
)

(PrintExercise
   "Exercise 3.9 - longest path, alternate version"
   '(longest-path 'a 'd '((a b c) (b c) (c d)))
   '(a b c d)
)
