// width/side is x
// height/top is y
// depth is z

faceplate_side = 49;
wood_thickness = 2;
knob_hole = 3;
smidge = 2;

window_height = 10;
window_width = 25;

knob_distance_from_top = 37;

window_distance_from_top = 10;
window_center_x = faceplate_side/2 - window_width/2;
window_center_y = faceplate_side - window_distance_from_top - window_height;

module window_hole() {
  translate([window_center_x, window_center_y, -smidge]) {
    cube([window_width, window_height, (wood_thickness + (2*smidge))]);
  }
}

module faceplate() {
  cube([faceplate_side,faceplate_side,wood_thickness]);
}

module knob_hole() {
  translate([faceplate_side/2, faceplate_side - knob_distance_from_top, 0]) { 
    cylinder(h = wood_thickness + smidge, d = knob_hole);
    }
  }

difference() {
  faceplate();
  window_hole();
  knob_hole();
  }
