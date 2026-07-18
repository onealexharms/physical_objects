(ns c3po.openscad)

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
