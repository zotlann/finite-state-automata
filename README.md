# finite-state-automata
Implementation of finite state automata in scheme.

To construct a machine, first construct it's sigma (machine alphabet), Q (set of all states), q0 (initial sate), F (set of accept states) , and delta (set of transition functions.

Define sigma as a list of single character scheme symbols

Ex: `(define sigma '(a b))`

For a machine with {a,b} as it's alphabet

Define Q as a list of symbols that represent state names

Ex: `(define Q '(q0 q1 q2 q3))` 

For a machine with sates q0,q1,q2, and q3.

Define states as a list containing it's identifier and then a list of pairs where the first element is a symbol and the second is the state to transition to on that symbol

Ex: `(define q0 '(q0 (a q1) (b q2) (lambda q3)))`

For a state named q0 that goes to q1 when recieving a, goes to q2 when recieving b, and has a lambda transition to q3.

Define q0 as any other state, the q0 passed to the machine is the initial state of the machine.

Define F as a list of symbols that represent accept state names

Ex: `(define F '(q0 q2))`

For a machine that accepts strings that end on q0 and q2.

Define delta as a list of states in the form (state-name (symbol transition-state)...)

Ex: `(define delta (list q0 q1 q2))`

For a machine with states q0,q1,q2 where q0 q1 q2 are defined and in the form (state-name (symbol transition-state) ...)

Finally define a machine using make-machine

Ex: `(define machine (make-machine sigma Q q0 F delta))`

Once you have a machine, you can use the machine-accepts? function to test if the machine accepts a certain string.

Ex: `(machine-accepts machine "ab")`

You can alo define the union of two machines using machine-union.  The union of two machines accepts strings that are accepted by either of the two machines original machines.

Ex: `(define m3 (machine-union m1 m2))`

Example Machine:

L(M) = {a^2n : n>= 0, a^3}
```scheme
(define sigma '(a))
(define q0 '(q0 (a q1) (a q3)))
(define q1 '(q1 (a q2)))
(define q2 '(q2 (a q1)))
(define q3 '(q3 (a q4)))
(define q4 '(q4 (a q5)))
(define q5 '(q5))
(define Q '(q0 q1 q2 q3 q4 q5))
(define F '(q2 q5))
(define delta (list q0 q1 q2 q3 q4 q5))
(define machine (make-machine sigma Q q0 F delta))

>(machine-accepts? machine "")
#t
>(machine-accepts? machine "a")
#f
>(machine-accepts? machine "aa")
#t
>(machine-accepts? machine "aaa")
#t
>(machine-accepts? machine "aaaa")
#t
>(machine-accepts? machine "aaaaa")
#f
>(machine-accepts? machine "b")
#f
```
