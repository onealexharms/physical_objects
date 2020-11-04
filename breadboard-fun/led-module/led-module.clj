(require '[open-circuitry.core :refer :all])

(define grid-spacing 2.54)
(define group-spacing (* 5 grid-spacing))
(define padding 5)
(define board-width (+ (* 8 grid-spacing) (* 2 padding)))
(define board-height (+ (* 20 grid-spacing) (* 2 padding)))
(define starting-x padding)
(define starting-y padding)
(define through-hole 0.8)

(defn socket [x y]
  [[:juncture {:at [x y] :drill through-hole, :trace (str "socket-led at " y)}]])

(defn led [x y]
  [[:juncture {:at [x y] :drill through-hole, :trace (str "socket-led at " y)}]
   [:juncture {:at [(+ x grid-spacing) y] :drill through-hole, :trace (str "resistor-led at " y)}]])

(defn resistor [x y]
  [[:juncture {:at [x y] :drill through-hole, :trace (str "resistor-led at " y)}]
   [:juncture {:at [(+ x (* 3 grid-spacing)) y], :drill through-hole, :trace "GND"}]])

(defn led-entourage [x y]
  (concat
    (socket x y)
    (led (+ x (* grid-spacing 2)) y)
    (resistor (+ x (* grid-spacing 5)) y)))

(defn group-of-four [x y]
  (concat
    (led-entourage x y)
    (led-entourage x (+ y (* grid-spacing 1)))
    (led-entourage x (+ y (* grid-spacing 2)))
    (led-entourage x (+ y (* grid-spacing 3)))))

(board "led-module"
  (vec (concat
         [:open-circuitry/board
          {:width board-width
           :height board-height}]
         (group-of-four starting-x (+ starting-y (* group-spacing 0)))
         (group-of-four starting-x (+ starting-y (* group-spacing 1)))
         (group-of-four starting-x (+ starting-y (* group-spacing 2)))
         (group-of-four starting-x (+ starting-y (* group-spacing 3)))
         [[:juncture {:at [starting-x (+ starting-y (* group-spacing 4))]
                      :trace "GND"
                      :drill through-hole}]
          [:juncture {:at [(+ starting-x (* grid-spacing 5)) (+ starting-y (* group-spacing 4))]
                      :trace "GND"}]])))
