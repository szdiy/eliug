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

(define-module (eliug plugins hello)
  #:use-module (eliug utils)
  #:use-module (eliug handlers)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:export (hello-installer))

(define *reply-list*
  '("heya!"
    "what's up dude?"))

(define (get-a-reply)
  (list-ref *reply-list*
            (random (length *reply-list*) *random-state*)))

(define (hello-installer irc)
  (lambda (msg)
    (and (bot-hit? msg "hello")
         (do-privmsg irc (msg:parse-target msg) (get-a-reply)))))
