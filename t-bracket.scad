wall_thickness = 1.5; 
wood_thickness = 2;
smidge = .01;

length = 20;
height = 10;
spacing = length + 10;

gap_width = wood_thickness + 0.5;
width = (wall_thickness * 2) + gap_width;
gap_length = length + 2;
one_arm = length/2 - width/2;

module solid(rotation) {
  rotate(rotation) {
    cube([length, width, height], center = true);
  }
}

module hollow(rotation) {
  rotate(rotation) {
    cube([gap_length, gap_width, height], center = true);
  }
}

module outside() {
  union() {
    solid(0);
    solid(90);
  }
}
 
module inside() {
  union() {
    translate([0, 0, wall_thickness]) {
      hollow(0); 
      hollow(90);
    }
  }
}

module bracket() {
  difference() {
    outside();
    inside();
  }
}

module t_bracket_slicer() {
  translate([-length/2, gap_width/2 + wall_thickness + smidge, - height/2 - smidge]) { 
    cube([length + smidge, one_arm, height + (smidge)], center = false);
  }
}

difference() {
  bracket();
  t_bracket_slicer();
}
