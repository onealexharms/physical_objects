#!/usr/bin/env bb

(def width 60);

(def extrusion-size 20);
(def extrusion-vertical-distance 75)

(def linear-rail-carriage-height 13)
(def linear-rail-carriage-width 27)
(def linear-rail-screw-distance 20)
(def linear-rail-screw-hole-diameter 3.5)
(def linear-rail-countersink-diameter (+ 6.5 0.5))
(def linear-rail-countersink-depth (+ 3.5 0.5))

(def leadscrew-height (- 75/2 39.47))

(def leadscrew-nut-diameter 10.5)
(def leadscrew-nut-flange-diameter 22)
(def leadscrew-nut-flange-thickness 4)
(def leadscrew-nut-length 10)
(def antibacklash-nut-width 11.2)
(def antibacklash-nut-depth 25)

;; 1mm (ruler=1mm) + 0.198in (gauge blocks=4.8mm) + 7.94/2 (half leadscrew=3.97mm) +))
;; 10mm (half extrusion) + 8mm (rail thickness) = 27.9992
(def leadscrew-distance-from-extrusion-centerline 28)

(def thickness 13)

(def carriage-bolt-square-width 45)
(def carriage-bolt-square-height 70)

(def z-axis-bracket
  {:type :box
   :size {:x width,
          :y thickness,
          :z (+ extrusion-vertical-distance linear-rail-screw-distance 10)}})

(defmulti openscad :type)

;; OpenSCAD cube is a box or rectangular cuboid, not necessarily a cube
(defmethod openscad :box
  [{{:keys [x y z]} :size}]
  (format "cube([%s, %s, %s], center=true);" x y z))

(spit "z_axis_bracket_clj.scad" (openscad z-axis-bracket))
