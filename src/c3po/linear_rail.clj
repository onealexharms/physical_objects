(ns c3po.linear-rail
  (:require [c3po.screw :as screw]))

(def mgn12h
  {::rail
   {::width 12
    ::height 8
    ::mounting-holes
    {::screw/counterbore    {::screw/diameter 6, ::screw/depth 4.5}
     ::screw/clearance-hole {::screw/diameter 3.5}
     ::pitch                25}}
   ::carriage
   {::height 13
    ::width  27
    ::length 45.4
    ::mounting-holes
    {::spacing {::lengthwise 20
                ::widthwise  20}
     ::screw   screw/m3-shcs}}})

(defn carriage-hole-pattern
  [rail]
  (let [{{{lengthwise ::lengthwise
           widthwise  ::widthwise} ::spacing} ::mounting-holes}
        (::carriage rail)
        w (/ widthwise 2)
        l (/ lengthwise 2)]
    [[(- w) (- l)]
     [(+ w) (- l)]
     [(+ w) (+ l)]
     [(- w) (+ l)]]))
