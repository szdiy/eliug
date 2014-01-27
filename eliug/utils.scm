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

(define-module (eliug utils)
  #:use-module (eliug config)
  #:use-module (eliug irregex)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:export (->str bot-hit? from-who user-hit? default-bot-hit-regex
            get-first-key irc-hit?))

(define-syntax-rule (->str fmt args ...) (format #f fmt args ...))

(define (from-who msg) (car (msg:prefix msg)))

(define default-bot-hit-regex 
  (string->irregex (format #f "~a:(.+)( |).*" *default-bot-name*)))
(define (default-bot-hit-pred key body)
  (define (->key b)
    (let ((m (irregex-search default-bot-hit-regex b)))
      (and m (irregex-match-substring m 1))))
  (format #t "MMR: ~a~%" body)
  (let ((bb (and body (->key body))))
    (format #t "MMR2: ~a~%" bb)
    (and bb (string=? (string-trim-both bb) key))))
(define* (bot-hit? msg key #:optional (pred default-bot-hit-pred))
  (let ((body (msg:trailing msg)))
    (pred key body)))

(define* (irc-hit? msg key pred)
  (let ((body (msg:trailing msg)))
    (pred key body)))

(define (get-first-key body)
  (let ((m (irregex-search default-bot-hit-regex body)))
    (and m (irregex-match-substring m 1))))

(define (default-user-hit-pred act user who)
  (and (eq? act 'JOIN)
       (string=? who user)))
(define* (user-hit? msg who #:optional (pred default-user-hit-pred))
  (let ((cmd (msg:command msg))
        (user (from-who msg)))
    (format #t "UHIT: ~a, ~a~%" user cmd)
    (pred cmd user who)))
