(ns c3po.stepper)

(def standard-steppers
  {::nema17 {::bolt-spacing 31}
   ::nema23 {::bolt-spacing 47.14}})

(defn lookup [stepper]
  (cond
   (get standard-steppers stepper) (get standard-steppers stepper)
   (map? stepper)                  stepper
   :else                           (throw (ex-info "No stepper type with key" {:key stepper}))))

(defn hole-pattern
  [stepper]
  (let [{spacing ::bolt-spacing} (lookup stepper)
        half (/ spacing 2)]
    [[(- half) (- half)]
     [(+ half) (- half)]
     [(+ half) (+ half)]
     [(- half) (+ half)]]))
