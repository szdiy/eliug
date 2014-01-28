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

(define-module (eliug plugins)
  #:use-module (eliug handlers)
  #:use-module (eliug config)
  #:use-module (eliug plugins hello)
  #:use-module (eliug plugins roll)
  #:use-module (eliug plugins leave-message)
  #:use-module (eliug plugins praise)
  #:use-module (eliug plugins translate))
  
(define-eliug-plugin hello PRIVMSG hello-installer)
(define-eliug-plugin roll PRIVMSG roll-installer)
(define-eliug-plugin leave-message PRIVMSG leave-message-installer)
(define-eliug-plugin give-message JOIN give-message-installer)
(define-eliug-plugin praise PRIVMSG praise-installer)
(and (not (file-exists? *default-msg-dir*)) (mkdir *default-msg-dir*))
(define-eliug-plugin translate PRIVMSG translate-installer)
