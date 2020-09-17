use <utility/round-bottom-box.scad>
wall_thickness = 4;
corner_radius = 3; 

box_length = 75;
box_width = 15;
box_height = 19;

lid_height = 0;

switch_hole_width = 5.8;
switch_hole_length = 18.5;
switch_tab_width = 5.3;
switch_tab_depth = 9.5;
switch_tab_height = 13.3;

cord_height = 7;
cord_width = 3.5;

module switch_tab_slots() {
  cube([switch_tab_width, switch_tab_depth, switch_tab_height], center = true);
}

module switch_hole() {
  translate([box_length/2, box_width/2, 0])
    cube([switch_hole_length, switch_hole_width, box_height], center = true);
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
  translate([box_length/2, box_width/2, box_height])
    cube([box_length, cord_width, cord_height], center = true);
}

module box_bottom() {
  difference() {
    hollow_round_bottom_box(box_length, box_width, box_height, corner_radius, wall_thickness);
    translate([box_length/2, box_width/2, (box_height/2 + wall_thickness)])
      switch_tab_slots();
    cord_slot();
  }
}

box_bottom();
translate([0, 0, 50]) 
  lid();
