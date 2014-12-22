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

(define-module (eliug config)
  #:use-module (srfi srfi-1)
  #:export (*default-bot-name* *default-port* pick-a-server
            *default-channel* *default-msg-dir* current-channel))

(define *default-bot-name* "eliug")
(define *default-port* 6667)
(define *default-channel* "#szdiy")
(define *default-msg-dir* "message")

(define current-channel (make-parameter #f))

(define *server-list*
  '(;;"banks.freenode.net"
    "bradbury.freenode.net"
    ;;"brooks.freenode.net"
    "roddenberry.freenode.net"
    "adams.freenode.net"
    "barjavel.freenode.net"
    "calvino.freenode.net"
    "cameron.freenode.net"
    "gibson.freenode.net"
    "hitchcock.freenode.net"
    "hobana.freenode.net"
    "holmes.freenode.net"
    "kornbluth.freenode.net"
    ;;"leguin.freenode.net"
    "orwell.freenode.net"
    "pratchett.freenode.net"
    "rajaniemi.freenode.net"
    "sendak.freenode.net"
    "wolfe.freenode.net"
    ;;"asimov.freenode.net"
    "card.freenode.net"
    ;;"dickson.freenode.net"
    "hubbard.freenode.net"
    "moorcock.freenode.net"
    "morgan.freenode.net"
    "wright.freenode.net"))

(define (gen-server-lst)
  (apply circular-list *server-list*))

(define pick-a-server
  (let ((sl (gen-server-lst)))
    (lambda ()
      (let ((s (car sl)))
	(set! sl (cdr sl))
	s))))
