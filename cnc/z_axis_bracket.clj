#!/usr/bin/env bb
(require
 '[c3po.core :as c3po]
 '[c3po.linear-rail :as lr]
 '[c3po.openscad :as openscad])

(def width 60);

(def extrusion-size 20);
(def extrusion-vertical-distance 75)

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

;;FIXME: cylinders should also be center?

;; 1mm (ruler=1mm) + 0.198in (gauge blocks=4.8mm) + 7.94/2 (half leadscrew=3.97mm) +))
;; 10mm (half extrusion) +c3po/ 8mm (rail thickness) = 27.9992
(def leadscrew-distance-from-extrusion-centerline 28)

(def thickness 13)

(defn- plate-hole [thickness diameter]
   (-> (c3po/cylinder {:height (+ thickness 0.2), :diameter diameter})
       (c3po/translate [0 0 (- 0.0 (/ thickness 2) 0.1)])))

(defn- plate-rail-holes
  [{:keys [thickness rail-distance rail-diameter], :as plate}]
  (for [x [(- (/ rail-distance 2)) (+ (/ rail-distance 2))]]
    (-> (plate-hole thickness rail-diameter)
        (c3po/translate [x 0 0]))))

(defn- endstop-bracket
  [{:keys [thickness]}]
  (-> (apply c3po/difference
             (c3po/box {:x 13, :y 28, :z thickness})
             (-> (c3po/box {:x 8.1, :y 12.5, :z (+ thickness 0.2)})
                 (c3po/translate [(/ (- 13 8) 2) 0 0]))
             (for [y [-9.75 +9.75]]
               (-> (plate-hole thickness 2.5)
                   (c3po/translate [0 y 0]))))
      (c3po/translate [(+ (/ width 2) 13/2) 0 0])))

(defn z-top-plate
  [{:keys [depth thickness rail-depth]
    :as plate
    :or {depth 40}}]
  (let [stepper-bolt-holes (for [x [-31/2 +31/2]
                                 y [-31/2 +31/2]]
                             (-> (c3po/union
                                   (plate-hole thickness 3.5)
                                   (-> (c3po/cylinder {:height 4, :diameter 6})
                                       (c3po/translate [0 0 (- 0 (/ thickness 2) 0.1)])))
                                 (c3po/translate [x y 0])))]
    (-> (c3po/difference
         (c3po/union
          (c3po/box {:x width, :y depth, :z thickness})
          (endstop-bracket {:thickness thickness}))
         (-> (apply c3po/union
                    (plate-hole thickness 22)
                    (concat
                     (plate-rail-holes plate)
                     stepper-bolt-holes))
             (c3po/translate [0 (- (/ depth 2) rail-depth) 0])))
        (c3po/translate [0 (- (/ depth 2)) (/ extrusion-vertical-distance 2)]))))

(defn z-bottom-plate
  [{:keys [depth thickness rail-diameter rail-depth]
    :as plate
    :or {depth 32}}]
  (-> (c3po/difference
       (c3po/union
        (c3po/box {:x width, :y depth, :z thickness})
        (endstop-bracket {:thickness thickness}))
       (-> (apply c3po/union
                  (plate-hole thickness 12)
                  (plate-rail-holes plate))
           (c3po/translate [0 (- (/ depth 2) rail-depth) 0])))
      (c3po/translate [0 (- (/ depth 2)) (- (/ extrusion-vertical-distance 2))])))

(defn z-axis-bracket
  [{:keys [::rail-type]
    :or {::rail-type ::lr/mgn12h}}]
  (let [{{carriage-height ::lr/height
          carriage-width  ::lr/width} ::lr/carriage,
         :as rail-type}
        (lr/lookup rail-type)

        plate                   (-> (c3po/box {:x width, :y thickness, :z (+ extrusion-vertical-distance linear-rail-screw-distance 10)})
                                    (c3po/translate [0 (/ thickness 2) 0]))
        m3-shcs-counterbored    (c3po/union
                                 (c3po/cylinder {:height (+ thickness 0.2), :diameter linear-rail-screw-hole-diameter})
                                 (c3po/cylinder {:height (+ linear-rail-countersink-depth 0.1), :diameter linear-rail-countersink-diameter}))
        chamfer                 2
        wall-thickness          2.5
        carriage-offset         (- (/ extrusion-vertical-distance 2)
                                   (/ carriage-width 2)
                                   0.5)
        ls-offset-from-back     (- leadscrew-distance-from-extrusion-centerline
                                   (/ extrusion-size 2)
                                   carriage-height)
        back-boss               (-> {:type   :linear-extrude
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
                                    (openscad/rotate [0 90 0])
                                    (c3po/translate [(- (/ width 2))
                                                     (- thickness ls-offset-from-back)
                                                     0]))
        linear-rail-screw-holes (apply
                                 c3po/union
                                 (for [x  [(- (/ linear-rail-screw-distance 2)) (+ (/ linear-rail-screw-distance 2))]
                                       z  [(- (/ extrusion-vertical-distance 2)) (+ (/ extrusion-vertical-distance 2))]
                                       zz [(- (/ linear-rail-screw-distance 2)) (+ (/ linear-rail-screw-distance 2))]]
                                   (-> m3-shcs-counterbored
                                       (openscad/rotate [-90 0 0])
                                       (c3po/translate [x -0.1 (+ z zz)]))))
        antibacklash-nut-drills (let [offset (Math/sqrt (- (Math/pow (/ leadscrew-nut-flange-diameter 2) 2)
                                                           (Math/pow (/ antibacklash-nut-width 2) 2)))
                                      depth  (- width (* 2 leadscrew-nut-flange-thickness) (/ leadscrew-nut-length 2))]
                                  (c3po/union
                                   (-> (c3po/cylinder {:height depth, :diameter 14})
                                       (c3po/translate [0 0 -0.1]))
                                   {:type     :hull
                                    :children (for [p [(- offset) (+ offset)]]
                                                (-> (c3po/cylinder {:height   antibacklash-nut-depth, :diameter 11.7})
                                                    (c3po/translate [p 0 -0.1])))}))
        plate-params            {:thickness     11,
                                 :rail-diameter 8,
                                 :rail-depth    18.25,
                                 :rail-distance 38}]
    (c3po/union
      (c3po/difference
        (c3po/union plate back-boss)
        linear-rail-screw-holes
        (-> (c3po/union
             (-> (c3po/cylinder {:height (+ width 0.2), :diameter (+ leadscrew-nut-diameter 0.5)})
                 (c3po/translate [0 0 -0.1]))
             (-> (c3po/cylinder {:height (+ leadscrew-nut-flange-thickness 0.1),
                                 :diameter (+ leadscrew-nut-flange-diameter 0.5)})
                 (c3po/translate [0 0 (+ (- width leadscrew-nut-flange-thickness) 0.1)]))
             antibacklash-nut-drills)
            (openscad/rotate [0 90 0])
            (c3po/translate [(- (/ width 2))
                             (- thickness ls-offset-from-back)
                             leadscrew-height])))
      (z-top-plate plate-params)
      (z-bottom-plate plate-params))))

(spit "cnc/z_axis_bracket.scad"
      (openscad/source
       (z-axis-bracket
        {::rail-type ::lr/mgn12h})))
