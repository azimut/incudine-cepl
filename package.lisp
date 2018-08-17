;;;; package.lisp

(uiop:define-package #:incudine-cepl
  ;; Collision with incudine
  (:shadowing-import-from #:cepl #:free)
  ;; Collision with cepl
  (:shadowing-import-from #:incudine
                          #:buffer-data
                          #:buffer
                          #:sample)
  (:import-from #:alexandria
                #:non-negative-fixnum)
  (:import-from #:incudine.analysis
                #:fft
                #:make-fft
                #:new-fft-plan
                #:fft-input
                #:compute-fft
                #:+FFT-PLAN-BEST+
                #:+FFT-PLAN-FAST+
                #:+FFT-PLAN-OPTIMAL+)  
  (:import-from #:incudine.vug
                #:define-vug
                #:define-ugen
                #:make-frame
                #:frame-ref
                #:delay1
                #:cout
                #:counter
                #:vuglet
                #:current-frame
                ;;#:buffer-play
                #:foreach-channel
                #:foreach-frame
                #:pan2
                #:with
                #:delay-s
                #:envgen
                #:vdelay
                #:stereo
                #:midi-note-on-p
                #:midi-note-off-p
                #:midi-program-p
                ;;#:mouse-button
                #:with-control-period
                #:white-noise
                #:samphold
                #:pole
                #:make-local-adsr
                #:make-local-perc
                #:phasor
                #:make-f32-array
                #:phasor-loop
                #:bpf
                #:lpf
                #:hpf
                #:buffer-read
                #:buffer-write
                #:butter-lp
                #:fractal-noise
                #:out
                #:~
                ;; nieveh!!!!
                ;;#:rand
                #:sine
                #:pulse
                #:line
                #:pink-noise
                #:dsp!)
  (:import-from #:incudine.util
                #:with-samples
                #:f32-ref
                #:db->lin
                #:+twopi+
                #:rt-eval
                ;;#:barrier
                #:return-value-p
                #:sample->fixnum
                #:non-negative-sample
                #:lin->db
                #:SAMPLE
                #:*SAMPLE-DURATION*
                #:*SAMPLE-RATE*
                #:*twopi-div-sr*
                #:+sample-zero+)
  (:use #:cl 
        #:cepl
        #:vari
        #:rtg-math
        #:nineveh
        #:temporal-functions
        #:incudine
        #:livesupport))
