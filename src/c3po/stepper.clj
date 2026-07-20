(ns c3po.stepper
 (:require
  [c3po.core :as c3po]
  [c3po.screw :as screw]))

(def nema17 {::bolt-spacing 31
             ::screw        screw/m3-shcs})
(def nema23 {::bolt-spacing 47.14
             ::screw        screw/m5-shcs})

(defn hole-pattern
  [stepper]
  (let [{spacing ::bolt-spacing} stepper
        half                     (/ spacing 2)]
    [[(- half) (- half)]
     [(+ half) (- half)]
     [(+ half) (+ half)]
     [(- half) (+ half)]]))

(defn counterbored-mounting-holes
  [{:keys [::screw], :as stepper} {:keys [thickness]}]
  (apply c3po/union
         (for [[bx by] (hole-pattern stepper)]
            (-> (screw/counterbore screw {:thickness thickness})
                (c3po/translate [bx by (- 0 (/ thickness 2) 0.1)])))))

