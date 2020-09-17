use <utility/round-bottom-box.scad>
box_length = 75;
box_width = 15;
box_height = 19;
lid_height = 4;
switch_width = 5.8;
switch_length = 18.5;

module switch_hole() {
  translate([box_length/2,box_width/2,(lid_height/2)])
    cube([switch_length, switch_width, lid_height], center = true);
}

module lid() {
  rotate([180, 0, 0]) 
    translate ([0, -box_width, 0])
      difference() {
        hollow_round_bottom_box(box_length, box_width, lid_height, 2, 2);
        switch_hole();
      }
}

hollow_round_bottom_box(box_length, box_width, box_height, 2, 2);
translate([0,0,25]) 
  lid();
