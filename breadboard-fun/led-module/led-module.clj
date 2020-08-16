(require '[dali.io :as io])

(defn- hole [row column]
  [:circle {:cx (* 2.54 (inc column))
            :cy (* 2.54 (inc row))
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

(def led-module
  [:dali/page
   (led-entourage 0)])

(io/render-svg led-module "led-module.svg")
