(define make-machine
  (lambda (sigma- Q- q0- F- delta-)
    (define sigma sigma-)
    (define Q Q-)
    (define q0 q0-)
    (define F F-)
    (define delta delta-)
    (lambda (method)
      (cond
	[(eq? method 'get-sigma) sigma]
	[(eq? method 'get-Q) Q]
	[(eq? method 'get-q0) (car q0)]
	[(eq? method 'get-F) F]
	[(eq? method 'get-delta) delta]
	(else
	  (begin
	    (display "Invalid operation on machine ")
	    (display method)(newline)))))))

(define machine-accepts?
  (lambda (machine str)
    (define machine-accepts?-helper
      (lambda (machine current-state lst)
	(define lambda-transitions (map cadr (filter (lambda (x) (eq? (car x) 'lambda)) (cdr (get-state-delta machine current-state)))))
	(cond
	  [(and (null? lst) (member? current-state (machine 'get-F))) #t]
	  [(and (null? lst) (null? lambda-transitions)) (member? current-state (machine 'get-F))]
	  [(null? lst) (apply-transitions machine lambda-transitions lst)]
	  (else
	    (let* [(symbol (car lst)) (symbol-transitions (map cadr (filter (lambda (x) (eq? (symbol->char (car x)) symbol)) (cdr (get-state-delta machine current-state)))))]
	      (or (apply-transitions machine lambda-transitions lst)
		  (apply-transitions machine symbol-transitions (cdr lst))))))))
    (define apply-transitions
      (lambda (machine transitions lst)
	(cond
	  [(null? transitions) #f]
	  (else
	    (or (machine-accepts?-helper machine (car transitions) lst)
		(apply-transitions machine (cdr transitions) lst))))))
    (define get-state-delta
      (lambda (machine state)
	(define get-delta-helper
	  (lambda (delta state)
	    (cond
	      [(null? delta) '(())]
	      [(eq? (caar delta) state) (car delta)]
	      (else
		(get-delta-helper (cdr delta) state)))))
	(get-delta-helper (machine 'get-delta) state)))

    (machine-accepts?-helper machine (machine 'get-q0) (string->list str))))

(define member?
  (lambda (tar lst)
    (cond
      [(null? lst) #f]
      [(eq? (car lst) tar) #t]
      (else (member? tar (cdr lst))))))

(define symbol->char
  (lambda (symbol)
    (car (string->list (symbol->string symbol)))))

(define filter
  (lambda (p lst)
    (cond
      [(null? lst) '()]
      [(p (car lst)) (cons (car lst) (filter p (cdr lst)))]
      (else
	(filter p (cdr lst))))))

(define machine-union
  (lambda (m1 m2)
    (define m1q0 (string->symbol (string-append "m1" (symbol->string (m1 'get-q0)))))
    (define m2q0 (string->symbol (string-append "m2" (symbol->string (m2 'get-q0)))))
    (define sigma (set-union (m1 'get-sigma) (m2 'get-sigma)))
    (define q0 `(q0 (lambda ,m1q0) (lambda ,m2q0)))
    (define F (set-union (map (lambda (x) (string->symbol (string-append "m1" (symbol->string x)))) (m1 'get-F))
			 (map (lambda (x) (string->symbol (string-append "m2" (symbol->string x)))) (m2 'get-F))))
    (define Q (set-union (map (lambda (x) (string->symbol (string-append "m1" (symbol->string x))))(m1 'get-Q))
			 (map (lambda (x) (string->symbol (string-append "m2" (symbol->string x))))(m2 'get-Q))))
    (define delta (cons q0 (set-union (map (prepend-state "m1") (m1 'get-delta))
				      (map (prepend-state "m2") (m2 'get-delta)))))
    (make-machine sigma Q q0 F delta)))

(define prepend-state 
  (lambda (str)
    (lambda (state)
      (cons (string->symbol (string-append str (symbol->string (car state)))) (map (lambda (x) (list (car x) (string->symbol (string-append str (symbol->string (cadr x)))))) (cdr state))))))

(define set-union
  (lambda (s1 s2)
    (cond
      [(null? s1) s2]
      [(not (member? (car s1) s2)) (cons (car s1) (set-union (cdr s1) s2))]
      (else
	(set-union (cdr s1) s2)))))
