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

(define-module (eliug plugins leave-message)
  #:use-module (eliug utils)
  #:use-module (eliug handlers)
  #:use-module (eliug config)
  #:use-module (eliug irregex)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:export (leave-message-installer give-message-installer))

(define leave-message-regex 
  (string->irregex (format #f "~a:[ ]*later tell ([^ ]+) (.*)$" *default-bot-name*)))

;; TODO: finish store and load message
(define (leave-message-installer irc)
  (lambda (msg)
    (define (check-who key body)
      (define m (irregex-search leave-message-regex body))
      (define (->who b) (and m (irregex-match-substring m 1)))
      (define (->what b) (and m (irregex-match-substring m 2)))
      (format #t "LMSG: ~a~%" body)
      (let ((who (and body (->who body)))
            (what (and body (->what body)))
            (from (from-who msg)))
        (format #t "LMSG2: ~a, ~a~%" who what)
        (and who what
             (values who
                     (format #f "~a, ~a said: ~a" who from what)))))
    (cond
     ((bot-hit? msg "later tell" check-who)
      values => (lambda (who mg)
           (store-the-message who ms)
           (do-privmsg irc (msg:parse-target msg) "got it.")))
           ;;(do-privmsg irc (msg:parse-target msg) mg)))
     )))

(define (give-message-installer irc)
  (lambda (msg)
    (let ((cmd (msg:command msg))
          (user (from-who msg)))
      (format #t "GMI: ~a, ~a: ~a~%" user cmd *msg*))
    (cond
     ((and *msg* (user-hit? msg "nalaginrut"))
      => (lambda (mg)
           (let ((lm (get-the-message "nalaginrut")))
             (do-privmsg irc (msg:parse-target msg) 
                         (format #f "welcome back ~a! you have ~a message~%"
                                 user (length lm)))
             (for-each (lambda (m) (do-privmsg irc (msg:parse-target msg) m))
                       lm)
             (set! *msg* #f)))))))
