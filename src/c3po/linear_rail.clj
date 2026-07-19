(ns c3po.linear-rail)

(def standard-rails
  {::mgn12h
   {::rail
    {::width 12
     ::height 8
     ::mounting-holes
     {::counterbore {::diameter 6, ::depth 4.5}
      ::clearance-hole {::diameter 3.5}
      ::pitch 25}}
    ::carriage
    {::height 13
     ::width 27
     ::length 45.4
     ::mounting-holes
     {::spacing {::lengthwise 20
                 ::widthwise 20}}}}})

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
