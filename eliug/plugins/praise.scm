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

(define-module (eliug plugins praise)
  #:use-module (eliug utils)
  #:use-module (eliug handlers)
  #:use-module (eliug config)
  #:use-module (eliug irregex)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:export (praise-installer))

(define *praise-list*
  '("nice" "good boy" "yeah" "great"))

(define *reply-list*
  '("你这么讨好我你老婆知道吗？"
    "有句名言是这么说的，花功夫讨好机器人你就2了。"))

(define (get-a-reply)
  (list-ref *reply-list*
            (random (length *reply-list*) *random-state*)))

(define re (string->irregex (format #f "~a:(.*)$" *default-bot-name*)))

(define (is-praise? _ body)
  (define (->key b)
    (let ((m (irregex-search re b)))
      (and m (irregex-match-substring m 1))))
  (let ((key (->key body)))
    (format #t "XXX: ~a~%" key)
    (and key
         (let ((k (string-trim-both key)))
           ((@ (srfi srfi-1) any)
            (lambda (s) (string=? k s))
            *praise-list*)))))

(define (praise-installer irc)
  (lambda (msg)
    (and (bot-hit? msg #f is-praise?)
         (do-privmsg irc (current-channel) (get-a-reply)))))
