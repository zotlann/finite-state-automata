(load "machine.scm")


;machine that accepts even binary number strings
(define esigma '(0 1))
(define eq0 '(q0 (0 q1) (1 q0)))
(define eq1 '(q1 (0 q1) (1 q0)))
(define eQ '(q0 q1))
(define eF '(q1))
(define edelta (list eq0 eq1))
(define even-acceptor (make-machine esigma eQ eq0 eF edelta))

;converts a decimal number to it's binary representation
(define decimal->binary 
  (lambda (n)
    (cond
      [(zero? n) 0]
      (else
	(+ (mod n 2)
	   (* 10 (decimal->binary (floor (/ n 2)))))))))

;uses the machine that accepts even binary number strings to test whethre or not a number is even
(define is-even?
  (lambda (n)
    (machine-accepts? even-acceptor (number->string (decimal->binary n)))))


;machine that accepts ternary number strings divisible by 3
(define fizzsigma '(0 1 2))
(define fizzq0 '(q0 (0 q1) (1 q0) (2 q0)))
(define fizzq1 '(q1 (0 q1) (1 q0) (2 q0)))
(define fizzQ '(q0 q1))
(define fizzF '(q1))
(define fizzdelta (list fizzq0 fizzq1))
(define fizz-machine (make-machine fizzsigma fizzQ fizzq0 fizzF fizzdelta))

;converts a decimal number to it's ternary representation
(define decimal->ternary
  (lambda (n)
    (cond
      [(zero? n) 0]
      (else
	(+ (mod n 3)
	   (* 10 (decimal->ternary (floor (/ n 3)))))))))

;returns true if n is divisible by 3, false otherwise
(define fizz?
  (lambda (n)
    (machine-accepts? fizz-machine (number->string (decimal->ternary n)))))

;machine that accepts decimal number strings divisible by 5
(define buzzsigma '(0 1 2 3 4 5 6 7 8 9))
(define buzzq0 '(q0 (0 q1) (1 q0) (2 q0) (3 q0) (4 q0) (5 q1) (6 q0) (7 q0) (8 q0) (9 q0)))
(define buzzq1 '(q1 (0 q1) (1 q0) (2 q0) (3 q0) (4 q0) (5 q1) (6 q0) (7 q0) (8 q0) (9 q0)))
(define buzzQ '(q0 q1))
(define buzzF '(q1))
(define buzzdelta (list buzzq0 buzzq1))
(define buzz-machine (make-machine buzzsigma buzzQ buzzq0 buzzF buzzdelta))

;returns true if n is divisible by 5, false otherwise
(define buzz?
  (lambda (n)
    (machine-accepts? buzz-machine (number->string n))))

;returns fizz on numbers divisible by 3, buzz for numbers divisible by 5, fizzbuzz for numbers
;divisible by 15, and n otherwise
(define fizzbuzz
  (lambda (n)
    (cond
      [(and (fizz? n) (buzz? n)) "fizzbuzz"]
      [(fizz? n) "fizz"]
      [(buzz? n) "buzz"]
      (else n))))
;constructs a list of numbers 1 to 100
(define 1-100
  (lambda ()
    (letrec ((x (lambda (curr end)
		  (cond
		    [(eq? curr end)(cons end '())]
		    (else
		      (cons curr (x (+ curr 1) end)))))))
      (x 1 100))))
;constructs a list of fizzbuzz for 1 to 100
(map fizzbuzz (1-100))

