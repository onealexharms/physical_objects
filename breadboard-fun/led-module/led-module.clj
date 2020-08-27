(require '[opencircuit.core :refer :all])

(define grid-spacing 2.54)
(define group-spacing (* 5 grid-spacing))
(define row-spacing (* 1.5 grid-spacing))
(define column-spacing grid-spacing)
(define margin 25)
(define board-width 110)
(define board-height 110)

(defn- hole [x y]
  [:circle {:cx x 
            :cy y
            :r 0.5
            :fill :black
            :stroke :none}])

(define socket
  (hole (* grid-spacing 1) 0))

(define led
  [:g (hole (* grid-spacing 3) 0)
      (hole (* grid-spacing 4) 0)])

(define resistor
  [:g (hole (* grid-spacing 6) 0)
      (hole (* grid-spacing 9) 0)])

(define led-entourage
  [:g socket
      led
      resistor])

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
                      :position [margin margin],
                      :step group-spacing}
     socket
     group-of-four
     group-of-four
     group-of-four
     group-of-four])

(define cutout
  [:rect {:dali/z-index -99,
          :stroke :black,
          :fill :white}
   [0 0]
   [board-width board-height]])

(define board
  [:dali/page
   cutout
   led-module])

(export board "led-module.svg")
