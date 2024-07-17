(require '[open-circuitry.core :refer :all])

(define grid-spacing 2.54)

;(defn resistor [x y]
;  [[:juncture {:at [x y] :drill through-hole, :trace (str "resistor-led at " y)}]
;   [:juncture {:at [(+ x (* 3 grid-spacing)) y], :drill through-hole, :trace "GND"}])

(board "spindle-driver"
  [:open-circuitry/board {:width 50, :height 30}
   
   ;; signal from CNC
   [:juncture {:at [grid-spacing grid-spacing], :drill 1.0 :trace "S+"}]
   [:juncture {:at [grid-spacing (* 2 grid-spacing)], :drill 1.0 :trace "S-"}]])

   ;[:juncture {:at [grid-spacing grid-spacing], :drill 1.0 :trace "V+"}]
   ;[:juncture {:at [grid-spacing (* 2 grid-spacing)], :drill 1.0 :trace "M-"}]

   ;[:juncture {:at [grid-spacing grid-spacing], :drill 1.0 :trace "V+"}]
   ;[:juncture {:at [grid-spacing (* 2 grid-spacing)], :drill 1.0 :trace "V-"}]])
