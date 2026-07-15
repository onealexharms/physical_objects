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

(defn translate [geom [x y z]]
  {:type   :affine-transformation
   :matrix [[1 0 0 x]
            [0 1 0 y]
            [0 0 1 z]
            [0 0 0 1]]
   :child  geom})

;; OpenSCAD-specific rotation
(defn rotate [geom [x y z]]
  (let [x (* x (/ Math/PI 180))
        y (* y (/ Math/PI 180))
        z (* z (/ Math/PI 180))
        sin #(Math/sin %)
        cos #(Math/cos %)]
    {:type   :affine-transformation
     :matrix [[(* (cos x) (cos y))
               (- (* (cos x) (sin y) (sin z))
                  (* (sin x) (cos z)))
               (+ (* (cos x) (sin y) (cos z))
                  (* (sin x) (sin z)))
               0]
              [(* (sin x) (cos y))
               (+ (* (sin x) (sin y) (sin z))
                  (* (cos x) (cos z)))
               (- (* (sin x) (sin y) (cos z))
                  (* (cos x) (sin z)))
               0]
              [(- (sin y))
               (* (cos y) (sin z))
               (* (cos y) (cos z))
               0]
              [0 0 0 1]]
     :child  geom}))

(def z-axis-bracket
  (let [plate               (-> {:type :box
                                 :size {:x width,
                                        :y thickness,
                                        :z (+ extrusion-vertical-distance linear-rail-screw-distance 10)}}
                                (translate [0 (/ thickness 2) 0]))
        chamfer             2
        wall-thickness      2.5
        carriage-offset     (- (/ extrusion-vertical-distance 2)
                               (/ linear-rail-carriage-width 2)
                               0.5)
        ls-offset-from-back (- leadscrew-distance-from-extrusion-centerline
                               (/ extrusion-size 2)
                               linear-rail-carriage-height)
        back-boss           (-> {:type   :linear-extrude
                                 :height width
                                 :child  {:type :polygon
                                          :points [[carriage-offset 0]
                                                   [carriage-offset
                                                    (+ (/ antibacklash-nut-width 2)
                                                       wall-thickness
                                                       (- chamfer)
                                                       5)]
                                                   [(- carriage-offset chamfer)
                                                    (+ (/ antibacklash-nut-width 2)
                                                       wall-thickness
                                                       5)]
                                                   [(+ (- carriage-offset) chamfer)
                                                    (+ (/ antibacklash-nut-width 2)
                                                       wall-thickness
                                                       5)]
                                                   [(- carriage-offset)
                                                    (+ (/ antibacklash-nut-width 2)
                                                       wall-thickness
                                                       (- chamfer)
                                                       5)]
                                                   [(- carriage-offset) 0]]}}
                                (rotate [0 90 0])
                                (translate [(- (/ width 2))
                                            (- thickness ls-offset-from-back)
                                            0]))]
    {:type       :difference
     :minuend    {:type :union
                  :children [plate
                             back-boss]}
     :subtrahend []}))

(defmulti openscad :type)

;; OpenSCAD cube is a box or rectangular cuboid, not necessarily a cube
(defmethod openscad :box
  [{{:keys [x y z]} :size}]
  (format "cube([%s, %s, %s], center=true);" x y z))

(defn- format-vector-of-vectors [v]
  (str "["
       (str/join ", " (map (fn [row]
                             (str "["
                                  (str/join ", " (map str row))
                                  "]"))
                           v))
       "]"))

(defmethod openscad :affine-transformation
  [{:keys [matrix child]}]
  (format "multmatrix(%s) %s" (format-vector-of-vectors matrix) (openscad child)))

(defmethod openscad :difference
  [{:keys [minuend subtrahend]}]
  (format "difference() {\n%s\n%s\n}\n"
          (openscad minuend)
          (str/join "\n" (map openscad subtrahend))))

(defmethod openscad :union
  [{:keys [children]}]
  (str "union() {\n"
       (str/join "\n" (map openscad children))
       "\n}\n"))

(defmethod openscad :polygon
  [{:keys [points]}]
  (format "polygon(points=%s);" (format-vector-of-vectors points)))

;; Research: is this OpenSCAD-specific?
(defmethod openscad :linear-extrude
  [{:keys [height child]}]
  (format "linear_extrude(%d) %s" height (openscad child)))

(spit "z_axis_bracket_clj.scad" (openscad z-axis-bracket))
