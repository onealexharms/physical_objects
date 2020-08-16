(require
  '[dali.io :as io]
  '[dali.layout.distribute]
  '[dali.layout.stack])

(def ^:private grid-spacing 2.54)
(def ^:private group-spacing (* 3 grid-spacing))
(def ^:private row-spacing (* 1.5 grid-spacing))
(def ^:private column-spacing grid-spacing)
(def ^:private margin 25)

(defn- hole [x y]
  [:circle {:cx x 
            :cy y
            :r 0.5
            :fill :black}])

(defn- socket [y]
  (hole (* grid-spacing 1) y))

(defn- led [y]
  [:g (hole (* grid-spacing 3) y)
      (hole (* grid-spacing 4) y)])

(def ^:private resistor
  [:g (hole (* grid-spacing 5) 0)
      (hole (* grid-spacing 8) 0)])

(def ^:private led-entourage
  [:g (socket 0)
      (led 0)
      resistor])

(defn- group-of-four [group-number]
  [:dali/distribute {:direction :down,
                     :anchor :center,
                     :gap row-spacing}
   led-entourage
   led-entourage
   led-entourage
   led-entourage])

(def led-module
  [:dali/page
   [:dali/distribute {:direction :down,
                      :anchor :center,
                      :position [margin margin]
                      :gap group-spacing}
     (group-of-four 0)
     (group-of-four 1)
     (group-of-four 2)
     (group-of-four 3)]])

(io/render-svg led-module "led-module.svg")
