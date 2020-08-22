(require
  '[dali.io :as io]
  '[dali.layout.distribute])

(def ^:private grid-spacing 2.54)
(def ^:private group-spacing (* 5 grid-spacing))
(def ^:private row-spacing (* 1.5 grid-spacing))
(def ^:private column-spacing grid-spacing)
(def ^:private margin 25)

(defn- hole [x y]
  [:circle {:cx x 
            :cy y
            :r 0.5
            :fill :black}])

(def ^:private socket
  (hole (* grid-spacing 1) 0))

(def ^:private led
  [:g (hole (* grid-spacing 3) 0)
      (hole (* grid-spacing 4) 0)])

(def ^:private resistor
  [:g (hole (* grid-spacing 5) 0)
      (hole (* grid-spacing 8) 0)])

(def ^:private led-entourage
  [:g socket
      led
      resistor])

(def ^:private group-of-four
  [:dali/distribute {:direction :down,
                     :anchor :center,
                     :step grid-spacing}
   led-entourage
   led-entourage
   led-entourage
   led-entourage])

(def led-module
  [:dali/page
   [:dali/distribute {:direction :down,
                      :anchor :center,
                      :position [margin margin]
                      :step group-spacing}
     group-of-four
     group-of-four
     group-of-four
     group-of-four]])

(io/render-svg led-module "led-module.svg")