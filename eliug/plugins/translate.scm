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

(define-module (eliug plugins translate)
  #:use-module (eliug utils)
  #:use-module (eliug handlers)
  #:use-module (eliug config)
  #:use-module (eliug irregex)
  #:use-module (irc irc)
  #:use-module ((irc message) #:renamer (symbol-prefix-proc 'msg:))
  #:use-module (web client)
  #:use-module (web uri)
  #:use-module (web response)
  #:use-module (ice-9 receive)
  #:export (translate-installer))

(define (->google lang txt) 
  (define (-> lang txt)
    (format #f "http://translate.google.com.hk/?langpair=~a&text=~a"
            lang (uri-encode txt)))
  (catch #t
    (lambda () 
      (http-get (-> lang txt) #:headers '((User-agent . "Mozilla/5.0"))))
    (lambda e
      (values #f "网络有点不舒服，待会儿再试试..."))))

(define *tr-re* (string->irregex "TRANSLATED_TEXT='([^']+)';" 'fast))
(define (->result txt)
  (define m (irregex-search *tr-re* txt))
  (and m (irregex-match-substring m 1)))

(define *hit-tr-re* (string->irregex ",tr (.*) << ([|a-zA-Z-]+)$")) 
(define (get-txt key body)
  (define m (irregex-search *hit-tr-re* body))
  (define (get n) (and m (irregex-match-substring m n)))
  (define (trim s) (string-trim-both s))
  (define lang (and m (trim (get 2))))
  (define txt (and m (trim (get 1))))
  (cond
   ((not m) #f) ; no hit
   ((string-null? lang)
    "Are you kidding me?! What language do you want?")
   ((string-null? txt) "Are you mad? Where is the text to translate?!")
   (else 
    (receive (r b) 
        (->google lang txt) 
      (cond
       ((= (response-code r) 200)
	(let* ((len (string-length b))
	       (ret (->result (substring b (- len (+ 500 (string-length txt)))))))
	  (if (string=? ret txt)
	      "sorry I don't know."
	      (format #f "it means: ~a" ret))))
       (else (format #f "貌似股哥有点问题...(~a)" (response-code r))))))))

(define (translate-installer irc)
  (lambda (msg)
    (let ((who (from-who msg)))
      (cond
       ((irc-hit? msg ",tr" get-txt)
        => (lambda (result)
             (let ((s (format #f "~a, ~a" who result)))
               (do-privmsg irc (current-channel) s))))))))
