;;;; incudine-cepl.lisp

(in-package #:incudine-cepl)

(defvar *step*  nil)
(defvar *c-arr* nil)
(defvar *tex*   nil)
(defvar *s-tex* nil)
(defvar *bs*    nil)

;; Hardcoded lenght of the external array set to 512
(dsp! monitor-master ((index fixnum))
  (:defaults 0)
  (setf (aref-c *c-arr* index)
        (coerce (audio-out 0) 'single-float))
  (setf index
        (mod (1+ index) 512)))

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
;;         (offset (abs (sin time)))
         (wave (- 1 (smoothstep (v4! 0f0)
                                (v4! (* .1 (abs (sin time))))
                                (abs (- wave (- (y uv) offset)))))))
    wave))

(defpipeline-g pipe (:points)
  :fragment (frag :vec2))

(defun initialize ()
  "runs once, can be called on repl to reset the state...
   by also removing the (unless)"
  (unless *bs*
    (setf *bs* (make-buffer-stream nil :primitive :points)))
  (unless *step*
    (setf *step* (make-stepper (seconds .05) (seconds 1))))
  (unless *c-arr*
    (setf *c-arr* (make-c-array nil :dimensions 512
                                :element-type :float))
    (setf *tex* (make-texture *c-arr*))
    (setf *s-tex* (cepl:sample *tex*))))

(defun draw! ()
  "runs each drawing cycle"
  (when (funcall *step*)
    (cepl:free *tex*)
;;    (cepl:free *s-tex*)
    (setf *tex* (make-texture *c-arr*))
    (setf *s-tex* (cepl:sample *tex*)))
  (let ((res (surface-resolution (current-surface))))
    (setf (viewport-resolution (current-viewport))
          res)
    (as-frame
      (map-g #'pipe *bs*
             :time (* .001 (get-internal-real-time))
             :texture *s-tex*))))

(def-simple-main-loop runplay (:on-start #'initialize)
  (draw!))
