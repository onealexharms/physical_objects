use <utility/round-bottom-box.scad>
box_width = 75;
box_length = 15;
box_height = 19;
lid_height = 4;
switch_width = 5.8;
switch_length = 18.5;

module switch_hole() {
  translate([box_width/2,box_length/2,(lid_height/2)])
    cube([switch_length, switch_width, lid_height], center = true);
}

module lid() {
  difference() {
    hollow_round_bottom_box(75, 15, lid_height, 2, 2);
    switch_hole();
  }
}

hollow_round_bottom_box(75, 15, 19, 2, 2);
translate([0,0,25]) 
  lid();
