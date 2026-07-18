(ns c3po.core)

(defn translate [geom [x y z]]
  {:type   :affine-transformation
   :matrix [[1 0 0 x]
            [0 1 0 y]
            [0 0 1 z]
            [0 0 0 1]]
   :child  geom})

(defn difference
  [minuend & subtrahends]
  {:type        :difference
   :minuend     minuend
   :subtrahends subtrahends})

(defn union [& children]
  {:type :union
   :children children})
