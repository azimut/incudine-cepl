;;;; incudine-cepl.lisp

;; We use a UBO instead of a texture to send the data.
;; The obvious difference we see is that a texture seems to smooth
;; the 512 values resulting in a smoother wave.
;; We also lose this smooth while using tex-ref. Probably fixable.

(in-package #:incudine-cepl)

;; We use this to control how ofter we update the wave image,
;; technically not needed at all, but it might come handy to
;; see the wave shape better.
(defparameter *step* (make-stepper (seconds .05) (seconds 1)))

(new-fft-plan 512 +FFT-PLAN-FAST+)
(defvar *fft* (make-fft 512))

;; Hardcoded lenght of the external array set to 512
;; for some reason 511 looks beeter with (counter)

(defvar *bs*  nil)
(defvar *mar* nil)
(defvar *ubo* nil)

;; Arbitrary fixed period
(dsp! monitor-master ((fft fft))
  (setf (fft-input fft) (audio-out 0))
  (with-control-period (5000)
    (compute-fft fft)))

;; (monitor-master *buf* :id 100)
;; (test-dsp :id 2)
;; (incudine:free (node 100))

(dsp! test-dsp (freq amp)
  (:defaults 440 .1)
  (with-samples
      ((in (sine freq))
       (in (* amp in)))
    (out in in)))

;;--------------------------------------------------
;; CEPL stuff

;; We are using a "single stage pipeline" here. Meaning there is
;; no need to define a vertex shader.

(defstruct-g (music :layout :std-140)
  (ffts (:double 512)))

;; Fragment shader
;; vec3 col = vec3( fft, 4.0*fft*(1.0-fft), 1.0-fft ) * fft;
(defun-g frag
    ((uv :vec2) &uniform (sound music :ubo) (time :float))
  (with-slots (ffts) sound
    (let* ((fft (float (aref ffts (int (ceil (* 100 (x uv)))))))
           (fft (* (v! fft (* 4 fft (- 1 fft)) (- 1 fft)) fft)))
      fft)))

(defpipeline-g pipe (:points)
  :fragment (frag :vec2))

(defun initialize ()
  "runs once, can be called on repl to reset the state...
   by also removing the (unless)"
  (unless *bs*
    (setf *bs*  (make-buffer-stream nil :primitive :points))
    (setf *mar* (make-c-array nil :dimensions 1 :element-type 'music))
    (setf *ubo* (make-ubo *mar*))))

(defun draw! ()
  "runs each drawing cycle"  
  (when (funcall *step*)
    ;; NOTE: ?
    (with-gpu-array-as-c-array (m (ubo-data *ubo*) :access-type :write-only)
      (incudine.external:foreign-copy-samples
       (c-array-pointer m)
       (incudine.analysis::fft-output-buffer *fft*)
       512)))
  
  (let ((res (surface-resolution (current-surface))))
    (setf (viewport-resolution (current-viewport))
          res)
    (as-frame
      (map-g #'pipe *bs*
             :time (* .001 (get-internal-real-time))
             :sound *ubo*))))

(def-simple-main-loop runplay (:on-start #'initialize)
  (draw!))
