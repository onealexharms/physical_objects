(ns cnc.z-axis-bracket
  (:require
   [c3po.core :as c3po]
   [c3po.linear-rail :as lr]
   [c3po.openscad :as openscad]
   [c3po.screw :as screw]
   [c3po.stepper :as stepper]))

(defn- plate-hole [thickness diameter]
   (-> (c3po/cylinder {:height (+ thickness 0.2), :diameter diameter})
       (c3po/translate [0 0 (- 0.0 (/ thickness 2) 0.1)])))

(defn z-top-plate
  [{:keys [::depth ::thickness ::leadscrew-depth ::width ::z-position ::stepper]
    :or {depth   40
         stepper stepper/nema17}}]
  {::depth                  depth
   ::thickness              thickness
   ::leadscrew-depth        leadscrew-depth
   ::width                  width
   ::z-position             z-position
   ::stepper                stepper})

(defn- z-top-plate-stepper-bolt-positions
  [{:keys [::stepper]}]
  (stepper/hole-pattern stepper))

(defn z-top-plate-model
  [params]
  (let [{:keys [::depth
                ::thickness
                ::leadscrew-depth
                ::width
                ::z-position]
         :as z-top-plate} (z-top-plate params)
        stepper-bolt-holes (for [[bx by] (z-top-plate-stepper-bolt-positions z-top-plate)]
                             (-> (c3po/union
                                   (plate-hole thickness 3.5)
                                   (-> (c3po/cylinder {:height 4, :diameter 6})
                                       (c3po/translate [0 0 (- 0 (/ thickness 2) 0.1)])))
                                 (c3po/translate [bx by 0])))]
    (-> (c3po/difference
         (c3po/box {:x width, :y depth, :z thickness})
         (-> (apply c3po/union
                    (plate-hole thickness 22)
                    stepper-bolt-holes)
             (c3po/translate [0 (- (/ depth 2) leadscrew-depth) 0])))
        (c3po/translate [0 (- (/ depth 2)) z-position]))))

(defn z-bottom-plate
  [{:keys [:depth
           ::thickness
           ::leadscrew-depth
           ::width
           ::z-position]
    :or {depth 32}}]
  {::depth           depth
   ::thickness       thickness
   ::leadscrew-depth leadscrew-depth
   ::width           width
   ::z-position      z-position})

(defn z-bottom-plate-model
  [params]
  (let [{:keys [::depth ::thickness ::leadscrew-depth ::width ::z-position]} (z-bottom-plate params)]
    (-> (c3po/difference
         (c3po/box {:x width, :y depth, :z thickness})
         (-> (plate-hole thickness 12)
             (c3po/translate [0 (- (/ depth 2) leadscrew-depth) 0])))
        (c3po/translate [0 (- (/ depth 2)) z-position]))))

(defn z-back-plate
  [{:keys [::width
           ::thickness
           ::bracket-height
           ::z-position
           ::extrusion-size
           ::extrusion-vertical-distance
           ::carriages-per-rail
           ::min-front-thickness
           ::leadscrew-height
           ::leadscrew-nut
           ::x-rail-type]}]
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
          {mounting-screw ::lr/screw} ::lr/mounting-holes} ::lr/carriage}
        x-rail-type

        carriage-spacing            (+ carriage-length 0.5)
        total-carriage-length       (- (* carriages-per-rail carriage-spacing) 0.5)
        carriage-offsets            (for [i (range carriages-per-rail)]
                                      (* (- i (/ (dec carriages-per-rail) 2)) carriage-spacing))
        ls-offset-from-back         (- leadscrew-distance-from-extrusion-centerline
                                       (/ extrusion-size 2)
                                       carriage-height)
        leadscrew-shaft-radius      (/ (+ leadscrew-nut-diameter 0.5) 2)
        leadscrew-max-forward-shift (- thickness ls-offset-from-back leadscrew-shaft-radius)
        carriage-forward-shift      (min (- carriage-height 1)
                                         (- thickness min-front-thickness)
                                         leadscrew-max-forward-shift)
        leadscrew-y                 (- thickness ls-offset-from-back carriage-forward-shift)]
    {::width                                        width
     ::thickness                                    thickness
     ::bracket-height                               bracket-height
     ::z-position                                   z-position
     ::extrusion-size                               extrusion-size
     ::extrusion-vertical-distance                  extrusion-vertical-distance
     ::carriages-per-rail                           carriages-per-rail
     ::min-front-thickness                          min-front-thickness
     ::leadscrew-height                             leadscrew-height
     ::leadscrew-nut                                leadscrew-nut
     ::x-rail-type                                  x-rail-type
     ::leadscrew-nut-diameter                       leadscrew-nut-diameter
     ::leadscrew-nut-flange-diameter                leadscrew-nut-flange-diameter
     ::leadscrew-nut-flange-thickness               leadscrew-nut-flange-thickness
     ::leadscrew-distance-from-extrusion-centerline leadscrew-distance-from-extrusion-centerline
     ::carriage-width                               carriage-width
     ::mounting-screw                               mounting-screw
     ::total-carriage-length                        total-carriage-length
     ::carriage-offsets                             carriage-offsets
     ::carriage-forward-shift                       carriage-forward-shift
     ::leadscrew-y                                  leadscrew-y}))

(defn z-back-plate-model
  [params]
  (let [{:keys [::width
                ::thickness
                ::bracket-height
                ::z-position
                ::extrusion-vertical-distance
                ::leadscrew-nut-diameter
                ::leadscrew-nut-flange-diameter
                ::leadscrew-nut-flange-thickness
                ::carriage-width
                ::mounting-screw
                ::total-carriage-length
                ::carriage-offsets
                ::carriage-forward-shift
                ::leadscrew-y
                ::leadscrew-height]
         x-rail-type ::x-rail-type}
        (z-back-plate params)
        plate                     (-> (c3po/box {:x width, :y thickness, :z bracket-height})
                                      (c3po/translate [0 (/ thickness 2) (+ z-position (/ bracket-height 2))]))
        m3-shcs-counterbored      (screw/counterbored mounting-screw {:thickness thickness})
        x-carriage-mounting-holes (apply
                                   c3po/union
                                   (for [z       [(- (/ extrusion-vertical-distance 2)) (+ (/ extrusion-vertical-distance 2))]
                                         cx      carriage-offsets
                                         [dx dy] (lr/carriage-hole-pattern x-rail-type)]
                                     (-> m3-shcs-counterbored
                                         (openscad/rotate [-90 0 0])
                                         (c3po/translate [(+ cx dx) -0.1 (+ z dy)]))))
        carriage-cutouts          (apply c3po/union
                                         (for [z-pos [(- (/ extrusion-vertical-distance 2)) (+ (/ extrusion-vertical-distance 2))]]
                                           (-> (c3po/box {:x (+ total-carriage-length 1)
                                                          :y (+ carriage-forward-shift 0.1)
                                                          :z (+ carriage-width 1)})
                                               (c3po/translate [0
                                                                (+ (- thickness (/ carriage-forward-shift 2)) 0.05)
                                                                z-pos]))))]
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
                          leadscrew-height])))))

(defn z-axis-bracket
  [{:keys [::width
           ::thickness
           ::extrusion-size
           ::extrusion-vertical-distance
           ::leadscrew-height
           ::carriages-per-rail
           ::z-rail-length
           ::min-front-thickness
           ::leadscrew-nut
           ::stepper
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
         stepper                     stepper/nema17
         x-rail-type                 lr/mgn12h}}]
  (let [{{carriage-width  ::lr/width
          carriage-length ::lr/length} ::lr/carriage}
        x-rail-type

        carriage-spacing             (+ carriage-length 0.5)
        total-carriage-length        (- (* carriages-per-rail carriage-spacing) 0.5)
        width                        (max width total-carriage-length)
        plate-thickness              11
        min-height-for-carriages     (+ extrusion-vertical-distance carriage-width)
        back-plate-bottom-z          (- (/ min-height-for-carriages 2))
        bottom-plate-z               (- (/ extrusion-vertical-distance 2))
        bottom-plate-top-surface-z   (+ bottom-plate-z (/ plate-thickness 2))
        min-height-for-z-rail-length (+ (- bottom-plate-top-surface-z back-plate-bottom-z) z-rail-length plate-thickness)
        bracket-height               (max min-height-for-carriages min-height-for-z-rail-length)
        back-plate-top-z             (+ back-plate-bottom-z bracket-height)
        top-plate-z                  (- back-plate-top-z (/ plate-thickness 2))
        base-plate-params            {::thickness       plate-thickness
                                      ::leadscrew-depth 18.25
                                      ::width           width}]
    {::back-plate-params           {::width                       width
                                    ::thickness                   thickness
                                    ::bracket-height              bracket-height
                                    ::z-position                  back-plate-bottom-z
                                    ::extrusion-size              extrusion-size
                                    ::extrusion-vertical-distance extrusion-vertical-distance
                                    ::carriages-per-rail          carriages-per-rail
                                    ::min-front-thickness         min-front-thickness
                                    ::leadscrew-height            leadscrew-height
                                    ::leadscrew-nut               leadscrew-nut
                                    ::x-rail-type                 x-rail-type}
     ::top-plate-params            (assoc base-plate-params
                                          ::z-position top-plate-z
                                          ::stepper    stepper)
     ::bottom-plate-params         (assoc base-plate-params ::z-position bottom-plate-z)}))

(defn z-axis-bracket-model
  [params]
  (let [{:keys [::back-plate-params ::top-plate-params ::bottom-plate-params]}
        (z-axis-bracket params)]
    (c3po/union
      (z-back-plate-model back-plate-params)
      (z-top-plate-model top-plate-params)
      (z-bottom-plate-model bottom-plate-params))))

(defn -main [& _args]
  (spit "cnc/z_axis_bracket.scad"
        (openscad/source
         (z-axis-bracket-model
          {::x-rail-type        lr/mgn12h
           ::stepper            stepper/nema17
           ::carriages-per-rail 2
           ::z-rail-length      140}))))
