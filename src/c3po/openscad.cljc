(ns c3po.openscad
 (:require
  [clojure.string :as str]))

;; OpenSCAD-specific rotation
(defn rotate [geom [x y z]]
  (let [x (* x (/ Math/PI 180))
        y (* y (/ Math/PI 180))
        z (* z (/ Math/PI 180))
        sx (Math/sin x)
        cx (Math/cos x)
        sy (Math/sin y)
        cy (Math/cos y)
        sz (Math/sin z)
        cz (Math/cos z)]
    {:type   :affine-transformation
     :matrix [[(* cy cz), (- (* cz sx sy) (* cx sz)), (+ (* cx cz sy) (* sx sz))]
              [(* cy sz), (+ (* cx cz) (* sx sy sz)), (+ (* (- cz) sx) (* cx sy sz))]
              [(- sy)   , (* cy sx)                 , (* cx cy)]]
     :child  geom}))


(defmulti source :type)

;; OpenSCAD cube is a box or rectangular cuboid, not necessarily a cube
(defmethod source :box
  [{{:keys [x y z]} :size}]
  (format "cube([%s, %s, %s], center=true);" x y z))

(defmethod source :cylinder
  [{:keys [height diameter]}]
  (format "cylinder($fn=50, h=%s, d=%s);" height diameter))

(defn- format-vector-of-vectors [v]
  (str "["
       (str/join ", " (map (fn [row]
                             (str "["
                                  (str/join ", " (map str row))
                                  "]"))
                           v))
       "]"))

(defmethod source :affine-transformation
  [{:keys [matrix child]}]
  (format "multmatrix(%s) %s" (format-vector-of-vectors matrix) (source child)))

(defmethod source :difference
  [{:keys [minuend subtrahends]}]
  (format "difference() {\n%s\n%s\n}\n"
          (source minuend)
          (str/join "\n" (map source subtrahends))))

(defmethod source :union
  [{:keys [children]}]
  (str "union() {\n"
       (str/join "\n" (map source children))
       "\n}\n"))

(defmethod source :polygon
  [{:keys [points]}]
  (format "polygon(points=%s);" (format-vector-of-vectors points)))

;; Research: is this OpenSCAD-specific?
(defmethod source :linear-extrude
  [{:keys [height child]}]
  (format "linear_extrude(%s) %s" height (source child)))

(defmethod source :hull
  [{:keys [children]}]
  (str "hull() {\n"
       (str/join "\n" (map source children))
       "\n}\n"))
