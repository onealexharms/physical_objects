(require '[dali.io :as io])

(def ^:private grid-spacing 2.54)
(def ^:private group-spacing (* 3 grid-spacing))
(def ^:private row-spacing (* 1.5 grid-spacing))
(def ^:private column-spacing grid-spacing)

(defn- hole [row column]
  [:circle {:cx (* column-spacing (inc column))
            :cy (* row-spacing (inc row))
            :r 1
            :fill :black}])

(defn- socket [row]
  (hole row 0))

(defn- led [row]
  [:g (hole row 2)
      (hole row 3)])

(defn- resistor [row]
  [:g (hole row 4)
      (hole row 7)])

(defn- led-entourage [row]
  [:g (socket row)
      (led row)
      (resistor row)])

(defn- group-of-four [n]
  [:g 
   (led-entourage (* n 7))
   (led-entourage (+ 1 (* n 7)))
   (led-entourage (+ 2 (* n 7)))
   (led-entourage (+ 3 (* n 7)))])

(def led-module
  [:dali/page
   (group-of-four 0)
   (group-of-four 1)])

(io/render-svg led-module "led-module.svg")
