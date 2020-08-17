(require
  '[dali]
  '[dali.io :as io]
  '[dali.layout :as layout]
  '[dali.layout.distribute]
  '[dali.layout.stack]
  '[dali.layout.utils :refer [bounds->anchor-point place-by-anchor] :as utils])

(defmethod layout/layout-nodes :maitria/on-center
  [_ {{:keys [direction anchor distance]} :attrs} elements bounds-fn]
  (let [direction (or direction :right)
        anchor (or anchor :center)
        vertical? (or (= direction :down) (= direction :up))]
    (if vertical?
      (when (not (#{:center :left :right} anchor))
        (throw (Exception. (str "distribute layout supports only :center :left :right anchors for direction " direction "\n elements: " elements))))
      (when (not (#{:center :top :bottom} anchor))
        (throw (Exception. (str "distribute layout supports only :center :top :bottom anchors for direction " direction "\n elements: " elements)))))
    (let [elements (if (seq? (first elements)) (first elements) elements) ;;so that you map over elements etc
          bounds (map bounds-fn elements)

          [x y] (bounds->anchor-point anchor (first bounds))

          step distance

          element-pos (if vertical?
                          (fn element-pos [pos orig-pos] [(first orig-pos) pos])
                          (fn element-pos [pos orig-pos] [pos (second orig-pos)]))

          positions (condp = direction
                      :down  (range y Integer/MAX_VALUE step)
                      :up    (range y Integer/MIN_VALUE (- step))
                      :right (range x Integer/MAX_VALUE step)
                      :left  (range x Integer/MIN_VALUE (- step)))]
      (map (fn [e pos b]
             (place-by-anchor
              e anchor (element-pos pos (bounds->anchor-point anchor b)) b))
           elements positions bounds))))
(dali/register-layout-tag :maitria/on-center)

(def ^:private grid-spacing 2.54)
(def ^:private group-spacing (* 3 grid-spacing))
(def ^:private row-spacing (* 1.5 grid-spacing))
(def ^:private column-spacing grid-spacing)
(def ^:private margin 25)

(defn- hole [x y]
  [:circle {:cx x 
            :cy y
            :r 0.5
            :fill :black}])

(def ^:private socket
  (hole (* grid-spacing 1) 0))

(def ^:private led
  [:g (hole (* grid-spacing 3) 0)
      (hole (* grid-spacing 4) 0)])

(def ^:private resistor
  [:g (hole (* grid-spacing 5) 0)
      (hole (* grid-spacing 8) 0)])

(def ^:private led-entourage
  [:g socket
      led
      resistor])

(defn- group-of-four [group-number]
  [:maitria/on-center {:direction :down,
                        :anchor :center,
                        :distance grid-spacing}
   led-entourage
   led-entourage
   led-entourage
   led-entourage])

(def led-module
  [:dali/page
   [:dali/distribute {:direction :down,
                      :anchor :center,
                      :position [margin margin]
                      :gap group-spacing}
     (group-of-four 0)
     (group-of-four 1)
     (group-of-four 2)
     (group-of-four 3)]])

(io/render-svg led-module "led-module.svg")
