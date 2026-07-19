(ns c3po.linear-rail
  (:require [c3po.screw :as screw]))

(def standard-rails
  {::mgn12h
   {::rail
    {::width 12
     ::height 8
     ::mounting-holes
     {::screw/counterbore {::screw/diameter 6, ::screw/depth 4.5}
      ::screw/clearance-hole {::screw/diameter 3.5}
      ::pitch 25}}
    ::carriage
    {::height 13
     ::width 27
     ::length 45.4
     ::mounting-holes
     {::spacing {::lengthwise 20
                 ::widthwise 20}
      ::screw ::screw/m3-shcs}}}})

(defn lookup [rail-type]
  (cond
   (get standard-rails rail-type) (get standard-rails rail-type)
   (map? rail-type)               rail-type
   :else                          (throw (ex-info "No rail type with key" {:key rail-type}))))

(defn carriage-hole-pattern
  [rail-type]
  (let [{{{lengthwise ::lengthwise
           widthwise  ::widthwise} ::spacing} ::mounting-holes}
        (::carriage (lookup rail-type))
        w (/ widthwise 2)
        l (/ lengthwise 2)]
    [[(- w) (- l)]
     [(+ w) (- l)]
     [(+ w) (+ l)]
     [(- w) (+ l)]]))
