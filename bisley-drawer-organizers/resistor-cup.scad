use <things/cup.scad>

//depth is z axis, always.
//length is probably x
//width is probably y
//sorry about that
//max cup depth without label is 35, with label is 25

stubby = 25;
tall = 35;
tall_without_label = 45;

cup(cup_width_in_nibs = 4, cup_length_in_nibs = 3, cup_depth = 25, label = true, split = false);
