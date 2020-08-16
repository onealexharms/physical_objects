(require '[dali.io :as io])

(def ^:private row-spacing (* 2 2.54))
(def ^:private column-spacing 2.54)

(defn- hole [row column]
  [:circle {:cx (* column-spacing (inc column))
            :cy (* row-spacing (inc row))
            :r 1
            :fill :black}])

(defn- socket [row]
  (hole row 0))

(defn- led [row]
  [:g (hole row 1)
      (hole row 2)])

(defn- resistor [row]
  [:g (hole row 3)
      (hole row 6)])

(defn- led-entourage [row]
  [:g (socket row)
      (led row)
      (resistor row)])

(defn- group-of-four [n]
  [:g 
   (led-entourage n)  
   (led-entourage (+ 1 n))
   (led-entourage (+ 2 n))
   (led-entourage (+ 3 n))]
)

(def led-module
  [:dali/page
   (group-of-four 0)])

(io/render-svg led-module "led-module.svg")
