(require '[open-circuitry.core :refer :all])

(define grid-spacing 2.54)
(define group-spacing (* 5 grid-spacing))
(define row-spacing (* 1.5 grid-spacing))
(define column-spacing grid-spacing)
(define padding 5)
(define board-width (+ (* 8 grid-spacing) (* 2 padding)))
(define board-height (+ (* 20 grid-spacing) (* 2 padding)))
(define starting-x padding)
(define starting-y padding)

(define drilled-hole
  [:circle {:cx 0
            :cy 0
            :r 0.5
            :fill :black
            :stroke :none}])

(define socket
  drilled-hole)

(define led
  [:g (position drilled-hole (* grid-spacing 0) 0)
      (position drilled-hole (* grid-spacing 1) 0)]) 

(define resistor
  [:g (position drilled-hole (* grid-spacing 0) 0)
      (position drilled-hole (* grid-spacing 3) 0)])

(define led-entourage
  [:g (position socket (* grid-spacing 0) 0)
      (position led (* grid-spacing 2) 0)
      (position resistor (* grid-spacing 5) 0)])

(define group-of-four
  [:dali/distribute {:direction :down,
                     :anchor :center,
                     :step grid-spacing}
   led-entourage
   led-entourage
   led-entourage
   led-entourage])

(define led-module
   [:dali/distribute {:direction :down,
                      :anchor :bottom,
                      :step group-spacing}
     (position socket (* grid-spacing 0) 0)
     group-of-four
     group-of-four
     group-of-four
     group-of-four])

(board "led-module"
  [:open-circuitry/board
   {:width board-width
    :height board-height}
   [:juncture {:at [25 19] :drill 1}]
   [:juncture {:at [5 40] :drill 1}]
   [:juncture {:at [5 6] :drill 1}]])
