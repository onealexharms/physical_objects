use <things/drawer-insert.scad>
include <data/bisley-5-drawer-cabinet.data>

//we want a shorter insert, disregarding drawer height
//drawer_insert(drawer_length, drawer_width, drawer_height, drawer_lip_thickness);

drawer_insert(drawer_length, drawer_width, 30, drawer_lip_thickness);
