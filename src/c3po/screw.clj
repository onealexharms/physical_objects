(ns c3po.screw
  (:require [c3po.core :as c3po]))

(def m3-shcs
  {::counterbore    {::diameter 6.5, ::depth 3.5}
   ::clearance-hole {::diameter 3.5}})

(def m5-shcs
  {::counterbore    {::diameter 9.5, ::depth 5.5}
   ::clearance-hole {::diameter 5.5}})

(defn counterbore
  [screw {:keys [thickness]}]
  (let [{{clearance-diameter   ::diameter} ::clearance-hole
         {counterbore-diameter ::diameter
          counterbore-depth    ::depth}    ::counterbore}
        screw]
    (c3po/union
     (c3po/cylinder {:height (+ thickness 0.2), :diameter clearance-diameter})
     (c3po/cylinder {:height counterbore-depth, :diameter counterbore-diameter}))))
