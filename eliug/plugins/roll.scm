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

(define-module (eliug plugins roll)
  #:use-module (eliug utils)
  #:use-module (eliug handlers)
  #:use-module (eliug config)
  #:use-module (eliug irregex)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:export (roll-installer))

(define (get-a-roll n)
  (cond
   ((zero? n) "0")
   ((not (integer? n)) (get-a-roll (round n)))
   ((< n 0) (format #f "-~a" (get-a-roll (- n))))
   (else (object->string (random n *random-state*)))))

(define (get-items-roll items)
  (let ((lst (regexp-split ",|，| " items)))
    (list-ref lst (random (length lst) *random-state*))))

(define roll-regex 
  (string->irregex (format #f "~a:[ ]*([^ ]+) (.*)$" *default-bot-name*)))
(define (check-roll key body)
  (define m (irregex-search roll-regex body))
  (define (get n) (and m (irregex-match-substring m n)))
  (define (->key b) (get 1))
  (define (->what b) (get 2))
  (let ((k (and body (->key body)))
        (n (and body (->what body))))
    (if (and k (string=? k key)) ; hit the key ?
        (or (and (not (string-null? n)) ; has number
                 (and (not (string-null? n))
                      (string->number (string-trim-both n)))) ; hit completely
            (get-items-roll n)) ; hit, but items
        #f))) ; no hit

(define (roll-installer irc)
  (lambda (msg)
    (let ((user (from-who msg)))
      (cond
       ((bot-hit? msg "roll" check-roll)
        => (lambda (n)
             (cond
              ((integer? n)
               (let ((reply (format #f "~a got ~a." user (get-a-roll n))))
                 (do-privmsg irc (msg:parse-target msg) reply)))
              ((string? n)
               (do-privmsg irc (msg:parse-target msg) n))
              (else #f))))))))
