;;  Copyright (C) 2014
;;      "Mu Lei" known as "NalaGinrut" <NalaGinrut@gmail.com>
;;  This file is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This file is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define-module (eliug handlers)
  #:use-module (irc irc)
  #:use-module (irc handlers)
  #:use-module (ice-9 receive)
  #:export (register-all-handlers define-eliug-plugin eliug-add-handler!))

(define *handler-table* (make-hash-table))

(define (eliug-add-handler! name cmd handler)
  (hash-set! *handler-table* name (list cmd handler)))

(define (get-cmd v) (car v))
(define (get-installer v) (cadr v))
(define (register-all-handlers irc)
  (hash-for-each
   (lambda (name v)
     (format #t "~a, ~a~%" name v)
     (add-simple-message-hook! irc ((get-installer v) irc) #:command (get-cmd v) #:tag name))
   *handler-table*))
  
(define-syntax-rule (define-eliug-plugin name cmd handler)
  (if (hash-ref *handler-table* 'name)
      (error 'define-eliug-plugin "the name is occupied, pick another!" 'name)
      (eliug-add-handler! 'name 'cmd handler)))
