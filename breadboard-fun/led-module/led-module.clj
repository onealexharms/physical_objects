(require '[dali.io :as io])

(def ^:private grid-spacing 2.54)
(def ^:private group-spacing (* 3 grid-spacing))
(def ^:private row-spacing (* 1.5 grid-spacing))
(def ^:private column-spacing grid-spacing)

(defn- hole [x row]
  [:circle {:cx x 
            :cy (* row-spacing (inc row))
            :r 0.5
            :fill :black}])

(defn- socket [row]
  (hole (* grid-spacing 1) row))

(defn- led [row]
  [:g (hole (* grid-spacing 3) row)
      (hole (* grid-spacing 4) row)])

(defn- resistor [row]
  [:g (hole (* grid-spacing 5) row)
      (hole (* grid-spacing 8) row)])

(defn- led-entourage [row]
  [:g (socket row)
      (led row)
      (resistor row)])

(defn- group-of-four [group-number]
  [:g 
   (led-entourage (* group-number group-spacing))
   (led-entourage (+ 1 (* group-number group-spacing)))
   (led-entourage (+ 2 (* group-number group-spacing)))
   (led-entourage (+ 3 (* group-number group-spacing)))])

(def led-module
  [:dali/page
   (group-of-four 0)
   (group-of-four 1)])

(io/render-svg led-module "led-module.svg")
