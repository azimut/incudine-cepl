;;;; incudine-cepl.asd

(asdf:defsystem #:incudine-cepl
  :description "Example integration between incudine and CEPL"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "GPL-3"
  :version "0.0.1"
  :serial t
  :depends-on (#:swank
               #:incudine
               #:cepl.sdl2
               #:livesupport
               #:nineveh
               #:temporal-functions
               #:rtg-math.vari)
  :components ((:file "package")
               (:file "incudine-cepl")))
