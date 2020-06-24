
(if (defined? -DEFINED-LIBZYNADDSUBFX)
    (abort '(aborted 'alread-defined)))

(define -DEFINED-LIBZYNADDSUBFX #t)

(import (lamu lang))
(use "libnewp")

; EXAMPLE
; (define a (start-zynaddsubfx  "hello" "zyn01" "zynaddsubfx" "midi_input" )) ;; open the synth
; (a) ;; close the synth
; NOTE that remote-id and remote-port-id cannot be changed.

; Other examples
; (define a (start-zynaddsubfx  "hello" "zyn01" "zynaddsubfx" "midi_input" #:load-file "/home/ats/Documents/test.xmz" )) ;; open the synth
; (define a (start-zynaddsubfx  "hello" "zyn01" "zynaddsubfx" "midi_input" #:load-file "/home/ats/Documents/test.xmz" #:no-gui #t )) ;; open the synth
;; It appears that #:no-gui causes the current login-session to crash; further investigation is needed. ; (Wed, 24 Jun 2020 12:55:01 +0900)

(define (start-zynaddsubfx local-id local-port-id remote-id remote-port-id 
                           #!key 
                           (dir  #!current-dir)
                           (no-gui #f)
                           (load-file #f))

  (let ((newp-proc #f))
    (open-output local-port-id )
    (set! newp-proc (apply newp
                           (append
                            (list
                             dir: dir 
                             "zynaddsubfx"
                             "--input=jack"
                             "--output=jack"
                             "--auto-connect")
                            (if no-gui
                                (list "--no-gui")
                                (list))
                            (if load-file
                                (list (string-concatenate (list "--load=" load-file)))
                                (list)))))
    (newp-add newp-proc)
    (sleep 3000)
    (connect 
     (string-concatenate (list local-id ":" local-port-id ))
     (string-concatenate (list  remote-id ":" remote-port-id )))
    (lambda ()
      (close-output local-port-id)
      (kilp newp-proc))))
