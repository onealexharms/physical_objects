use <utility/round-bottom-box.scad>
box_width = 75;
box_length = 15;
box_height = 19;
lid_height = 4;


hollow_round_bottom_box(75, 15, 19, 2, 2);

difference() {
translate([0,0,25]) 
  hollow_round_bottom_box(75, 15, lid_height, 2, 2);
translate([box_width/2,box_length/2,25+(lid_height/2)])
  cube([20,6.5,lid_height], center = true);
}
