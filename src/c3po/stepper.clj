(ns c3po.stepper)

(def nema17 {::bolt-spacing 31})
(def nema23 {::bolt-spacing 47.14})

(defn hole-pattern
  [stepper]
  (let [{spacing ::bolt-spacing} stepper
        half                     (/ spacing 2)]
    [[(- half) (- half)]
     [(+ half) (- half)]
     [(+ half) (+ half)]
     [(- half) (+ half)]]))
