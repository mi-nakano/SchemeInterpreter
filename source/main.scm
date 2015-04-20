;; Global variable
(define vartable '()) ;Table for Variables


;; Intepreter
(define (interpreter)
  (begin
    (println "Interpreter start.")
    (interpreter-body)
    (println "Interpreter end.")))

;; Interpreter body. Tail loop
(define (interpreter-body)
  (begin
    (iprint "input> ")
    (let ((sexp (read)))
      (if (end? sexp)
          '()
          (begin
            (let ((ret (my-eval sexp)))
              (cond 
                ((eq? ret #t) (iprintln "#t"))
                ((eq? ret #f) (iprintln "#f"))
                ((number? ret) (iprintln (number->string ret)))
                ((symbol? ret) (iprintln (symbol->string ret)))
                ((string? ret) (iprintln ret))))
            (interpreter-body))))))

;; Check input whether it is end term
(define (end? input)
  (if(equal? input 'quit) #t #f))

;; print
(define (print str)
  (display str))
(define (println str)
  (print str)
  (newline))
(define (iprint str)
  (print (string-append " " str)))
(define (iprintln str)
  (println (string-append " " str)))


;; eval s-expr
(define (my-eval sexp)
  (if (atom? sexp) 
      sexp ;sexp = atom
      (let ((func (car sexp)) (args (cdr sexp))) ;sexp != atom
        (cond
          ((equal? func '+) (fold + (cons 0 args )))
          ((equal? func '-) (fold - args))
          ((equal? func '*) (fold * (cons 1 args )))
          ((equal? func '/) (fold / args))
          ((equal? func 'number?) (execUnaryFunc number? args))
          ((equal? func '=) (execBinaryFunc = args))
          ((equal? func '<) (execBinaryFunc < args))
          ((equal? func '<=) (execBinaryFunc <= args))
          ((equal? func '>) (execBinaryFunc > args))
          ((equal? func '>=) (execBinaryFunc >= args))
          
          ((equal? func 'boolean?) (execUnaryFunc boolean? args))
          ((equal? func 'not) (execUnaryFunc not args))
          
          ((equal? func 'string?) (execUnaryFunc string? args))
          
          ((equal? func 'procedure?) (execUnaryFunc procedure? args))
          
          ((equal? func 'eq?) (execBinaryFunc eq? args))
          ((equal? func 'neq?) (execBinaryFunc neq? args))
          ((equal? func 'equal?) (execBinaryFunc equal? args))
          
          (else (car args))))))

;; Macro
;; if num of args is less than needed return error,else exec function(1arg)
(define (execUnaryFunc func args)
  (func (car args)))

;; Macro
;; if num of args is less than needed return error,else exec function(2arg)
(define (execBinaryFunc func args)
  (func (car args) (cadr args)))

;; atom?
(define (atom? sexp)
  (cond
    ((pair? sexp) #f)
    ((null? sexp) #f)
    (else #t)))

;;fold (func:procedure which have 2args)
(define (fold func list)
  (cond
    ((null? list) '())
    ((eq? (length list) 1) (func (car list)))
    (else (func (car list) (fold-loop func (cdr list))))))
(define (fold-loop func list)
  (cond 
    ((eq? (length list) 1)(car list))
    (else (func(func (car list) (fold-loop func (cdr list)))))))

;; add variable to vartable
(define (addVariable name type value)
  (let ((newvar (cons name (cons type (cons value '() )))))
    (set! vartable (append vartable (cons newvar '() )))))

;; get variable from vartable
(define (getVariable varname)
  (getFromVartable vartable varname))
(define (getFromVartable currenttable varname)
  (cond
    ((null? currenttable) #f)
    ((equal? (caar currenttable) varname) (car currenttable))
    (else (getFromVariable (cdr currenttable) varname))))



(interpreter) ;Run Interpreter