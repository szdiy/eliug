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

(define-module (eliug main)
  #:use-module (eliug utils)
  #:use-module (irc irc)
  #:use-module (irc handlers)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:use-module (eliug config)
  #:use-module (eliug handlers)
  #:use-module (eliug plugins)
  #:use-module (ice-9 match)
  #:export (make-bot run-bot main))

(define (init-bot irc)
  (install-ping-handler! irc)
  (install-printer! irc)
  (register-all-handlers irc))

(define* (make-bot #:key (name *default-bot-name*)
                   (server (pick-a-server))
                   (port *default-port*))
  (define irc (make-irc #:nick name #:server server #:port port))
  (init-bot irc)
  irc)

(define* (run-bot irc #:optional (channel *default-channel*))
  (catch #t
    (lambda ()
      (do-connect irc)
      (do-register irc)
      (do-join irc channel)
      (parameterize ((current-channel channel))
        (do-runloop irc)))
    (lambda e
      (format #t "ERROR: ~a~%" e)
      (display "Restarting bot...\n")
      (sleep 600)
      (run-bot (make-bot #:name (nick irc)) channel))))

(define (main)
  (setlocale LC_ALL "")
  (match (command-line)
   ((_) 
    (run-bot (make-bot)))
   ((_ bot channel)
    (run-bot (make-bot #:name bot) channel))
   ((_ bot)
    (run-bot (make-bot #:name bot)))
   ((_ (= (lambda (s) (string=? s "-c")) channel))
    (run-bot (make-bot) channel))
   (else (display "./run [bot] [channel]"))))
