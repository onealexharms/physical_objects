(require '[opencircuit.core :refer :all])

(define grid-spacing 2.54)
(define group-spacing (* 5 grid-spacing))
(define row-spacing (* 1.5 grid-spacing))
(define column-spacing grid-spacing)
(define margin 25)
(define board-width 110)
(define board-height 110)

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
                      :position [margin margin],
                      :step group-spacing}
     (position socket (* grid-spacing 0) 0)
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
