;;;; incudine-cepl.lisp

(in-package #:incudine-cepl)

;; We use this to control how ofter we update the wave image,
;; technically not needed at all, but it might come handy to
;; see the wave shape better.
(defparameter *step* (make-stepper (seconds .05) (seconds .5)))

(defvar *car* nil)
(defvar *tex* nil)
(defvar *sam* nil)
(defvar *bs*  nil)

;; Hardcoded lenght of the external array set to 512
;; for some reason 511 looks beeter with (counter)
(dsp! monitor-master ()
  (setf (aref-c *car* (counter 0 511 :loop-p t))
        (coerce (audio-out 0) 'single-float)))

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

;; Fragment shader
(defun-g frag
    ((uv :vec2) &uniform (texture :sampler-1d) (time :float))
  (let* ((tx (* 1 (x uv)))
         (wave (texture texture tx))
         (offset .5)
         ;;(offset (abs (sin time)))
         (smooth .01)
         ;;(smooth (* .1 (abs (sin time))))
         (wave (- 1 (smoothstep (v4! 0f0)
                                (v4! smooth)
                                (abs (- wave (- (y uv) offset)))))))
    wave))

(defpipeline-g pipe (:points)
  :fragment (frag :vec2))

(defun initialize ()
  "runs once, can be called on repl to reset the state...
   by also removing the (unless)"
  (unless *bs*
    (setf *bs*  (make-buffer-stream nil :primitive :points))
    (setf *car* (make-c-array nil :dimensions 512
                                :element-type :float))
    (setf *tex* (make-texture *car*)
          *sam* (cepl:sample *tex*))))

(defun draw! ()
  "runs each drawing cycle"
  (when (funcall *step*)
    (push-g *car* (texref *tex*)))
  (let ((res (surface-resolution (current-surface))))
    (setf (viewport-resolution (current-viewport))
          res)
    (as-frame
      (map-g #'pipe *bs*
             :time (* .001 (get-internal-real-time))
             :texture *sam*))))

(def-simple-main-loop runplay (:on-start #'initialize)
  (draw!))
