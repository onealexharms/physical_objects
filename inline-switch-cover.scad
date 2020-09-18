use <utility/round-bottom-box.scad>
wall_thickness = 3.6;
corner_radius = 3; 

box_length = 75;
box_width = 15;
box_wall_height = 19;
box_bottom_height = box_wall_height + corner_radius;
box_tab_height = 4;

lid_height = 0;

switch_hole_width = 6.8;
switch_hole_length = 19.5;

switch_tab_width = 6;
switch_tab_depth = 10;
switch_tab_height = 14;
switch_tab_x = (box_length + switch_tab_width)/2;
switch_tab_y = (box_width)/2;
switch_tab_z = (box_bottom_height) - switch_tab_height/2;

cord_height = 8;
cord_width = 4;
cord_slot_height = cord_height + box_tab_height;

module switch_tab_slots() {
  translate([switch_tab_x, switch_tab_y, switch_tab_z])
    cube([switch_tab_width, switch_tab_depth, switch_tab_height], center = true);
}

module switch_hole() {
  translate([box_length/2, box_width/2, 0])
    cube([switch_hole_length, switch_hole_width, box_wall_height], center = true);
}

module lid() {
  rotate([0, 180, 0])
    translate ([-box_length, 0, 0])
      difference() {
        hollow_round_bottom_box(box_length, box_width, lid_height, corner_radius, wall_thickness);
        switch_hole();
      }
}

module cord_slot() {
  translate([box_length/2, box_width/2, box_bottom_height])
#    cube([box_length, cord_width, cord_slot_height], center = true);
}

module box_bottom() {
  difference() {
    hollow_round_bottom_box(box_length, box_width, box_wall_height, corner_radius, wall_thickness);
    switch_tab_slots();
    cord_slot();
  }
}

box_bottom();
translate([0, 0, 50]) 
  lid();
