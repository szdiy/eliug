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
  (if (zero? n)
      "0"
      (object->string (random n *random-state*))))

(define roll-regex 
  (string->irregex (format #f "~a:[ ]*roll ([0-9]+).*" *default-bot-name*)))
(define (check-roll key body)
  (define m (irregex-search roll-regex body))
  (define (->key b) (and m (irregex-match-substring m 1)))
  (define (->num b) (and m (irregex-match-substring m 3)))
  (let ((k (and body (->key body)))
        (n (and body (->num body))))
    (and k (string=? (string-trim-both k) key)
         (and (string->number (string-trim-both n))))))

(define (roll-installer irc)
  (lambda (msg)
    (cond
     ((bot-hit? msg "roll" check-roll)
      => (lambda (n) (do-privmsg irc (msg:parse-target msg) (get-a-roll n)))))))
