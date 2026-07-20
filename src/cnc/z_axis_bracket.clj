(ns cnc.z-axis-bracket
  (:require
   [c3po.core :as c3po]
   [c3po.linear-rail :as lr]
   [c3po.openscad :as openscad]
   [c3po.screw :as screw]))

(defn- plate-hole [thickness diameter]
   (-> (c3po/cylinder {:height (+ thickness 0.2), :diameter diameter})
       (c3po/translate [0 0 (- 0.0 (/ thickness 2) 0.1)])))

(defn z-top-plate
  [{:keys [depth thickness rail-depth width z-position]
    :or {depth 40}}]
  (let [stepper-bolt-holes (for [x [-31/2 +31/2]
                                 y [-31/2 +31/2]]
                             (-> (c3po/union
                                   (plate-hole thickness 3.5)
                                   (-> (c3po/cylinder {:height 4, :diameter 6})
                                       (c3po/translate [0 0 (- 0 (/ thickness 2) 0.1)])))
                                 (c3po/translate [x y 0])))]
    (-> (c3po/difference
         (c3po/box {:x width, :y depth, :z thickness})
         (-> (apply c3po/union
                    (plate-hole thickness 22)
                    stepper-bolt-holes)
             (c3po/translate [0 (- (/ depth 2) rail-depth) 0])))
        (c3po/translate [0 (- (/ depth 2)) z-position]))))

(defn z-bottom-plate
  [{:keys [depth thickness rail-depth width z-position]
    :or {depth 32}}]
  (-> (c3po/difference
       (c3po/box {:x width, :y depth, :z thickness})
       (-> (plate-hole thickness 12)
           (c3po/translate [0 (- (/ depth 2) rail-depth) 0])))
      (c3po/translate [0 (- (/ depth 2)) z-position])))

(defn z-axis-bracket
  [{:keys [width
           thickness
           extrusion-size
           extrusion-vertical-distance
           leadscrew-height
           carriages-per-rail
           z-rail-length
           min-front-thickness
           ::leadscrew-nut
           ::x-rail-type]
    :or {width                       60
         thickness                   24
         extrusion-size              20
         extrusion-vertical-distance 75
         leadscrew-height            (- 75/2 39.47)
         carriages-per-rail          1
         z-rail-length               0
         min-front-thickness         10
         leadscrew-nut               {}
         x-rail-type                 ::lr/mgn12h}}]
  (let [{leadscrew-nut-diameter                       :diameter
         leadscrew-nut-flange-diameter                :flange-diameter
         leadscrew-nut-flange-thickness               :flange-thickness
         leadscrew-distance-from-extrusion-centerline :distance-from-extrusion-centerline
         :or {leadscrew-nut-diameter                       10.5
              leadscrew-nut-flange-diameter                22
              leadscrew-nut-flange-thickness               4
              leadscrew-distance-from-extrusion-centerline 20}}
        leadscrew-nut

        {{carriage-height ::lr/height
          carriage-width  ::lr/width
          carriage-length ::lr/length
          {{carriage-hole-lengthwise ::lr/lengthwise} ::lr/spacing
           mounting-screw ::lr/screw} ::lr/mounting-holes} ::lr/carriage,
         :as x-rail-type}
        (lr/lookup x-rail-type)

        carriage-spacing            (+ carriage-length 0.5)
        total-carriage-length       (- (* carriages-per-rail carriage-spacing) 0.5)
        width                       (max width total-carriage-length)
        carriage-offsets            (for [i (range carriages-per-rail)]
                                      (* (- i (/ (dec carriages-per-rail) 2)) carriage-spacing))
        plate-thickness             11
        min-height-for-carriages    (+ extrusion-vertical-distance carriage-width)
        back-plate-bottom-z         (- (/ min-height-for-carriages 2))
        bottom-plate-z              (- (/ extrusion-vertical-distance 2))
        bottom-plate-top-surface-z  (+ bottom-plate-z (/ plate-thickness 2))
        min-height-for-z-rail-length  (+ (- bottom-plate-top-surface-z back-plate-bottom-z) z-rail-length plate-thickness)
        bracket-height              (max min-height-for-carriages min-height-for-z-rail-length)
        back-plate-top-z            (+ back-plate-bottom-z bracket-height)
        top-plate-z                 (- back-plate-top-z (/ plate-thickness 2))
        plate                       (-> (c3po/box {:x width, :y thickness, :z bracket-height})
                                        (c3po/translate [0 (/ thickness 2) (+ back-plate-bottom-z (/ bracket-height 2))]))
        m3-shcs-counterbored        (screw/counterbored mounting-screw {:thickness thickness})
        ls-offset-from-back         (- leadscrew-distance-from-extrusion-centerline
                                       (/ extrusion-size 2)
                                       carriage-height)
        x-carriage-mounting-holes   (apply
                                     c3po/union
                                     (for [z       [(- (/ extrusion-vertical-distance 2)) (+ (/ extrusion-vertical-distance 2))]
                                           cx      carriage-offsets
                                           [dx dy] (lr/carriage-hole-pattern x-rail-type)]
                                       (-> m3-shcs-counterbored
                                           (openscad/rotate [-90 0 0])
                                           (c3po/translate [(+ cx dx) -0.1 (+ z dy)]))))
        leadscrew-shaft-radius      (/ (+ leadscrew-nut-diameter 0.5) 2)
        leadscrew-max-forward-shift (- thickness ls-offset-from-back leadscrew-shaft-radius)
        carriage-forward-shift      (min (- carriage-height 1)
                                         (- thickness min-front-thickness)
                                         leadscrew-max-forward-shift)
        leadscrew-y                 (- thickness ls-offset-from-back carriage-forward-shift)
        carriage-cutouts            (apply c3po/union
                                           (for [z-pos [(- (/ extrusion-vertical-distance 2)) (+ (/ extrusion-vertical-distance 2))]]
                                             (-> (c3po/box {:x (+ total-carriage-length 1)
                                                            :y (+ carriage-forward-shift 0.1)
                                                            :z (+ carriage-width 1)})
                                                 (c3po/translate [0
                                                                  (+ (- thickness (/ carriage-forward-shift 2)) 0.05)
                                                                  z-pos]))))
        plate-params                {:thickness  plate-thickness,
                                     :rail-depth 18.25,
                                     :width      width}]
    (c3po/union
      (c3po/difference
        plate
        x-carriage-mounting-holes
        carriage-cutouts
        (-> (apply c3po/union
                   (-> (c3po/cylinder {:height (+ width 0.2), :diameter (+ leadscrew-nut-diameter 0.5)})
                       (c3po/translate [0 0 -0.1]))
                   (for [z [-0.1 (+ (- width leadscrew-nut-flange-thickness) 0.1)]]
                     (-> (c3po/cylinder {:height (+ leadscrew-nut-flange-thickness 0.1),
                                         :diameter (+ leadscrew-nut-flange-diameter 0.5)})
                         (c3po/translate [0 0 z]))))
            (openscad/rotate [0 90 0])
            (c3po/translate [(- (/ width 2))
                             leadscrew-y
                             leadscrew-height])))
      (z-top-plate (assoc plate-params :z-position top-plate-z))
      (z-bottom-plate (assoc plate-params :z-position bottom-plate-z)))))

(defn -main [& _args]
  (spit "cnc/z_axis_bracket.scad"
        (openscad/source
         (z-axis-bracket
          {::x-rail-type         ::lr/mgn12h
           :carriages-per-rail 2
           :z-rail-length        140}))))
