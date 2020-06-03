width = 32; 
length  = 130;
depth = 25;
corner_radius = 5;
ledge_length = 10;

module shell_basis() {
  minkowski() {
    cube([length, width, depth], center = true);
    sphere(corner_radius);
  }
}

module shell_chop_off() {
  chop_depth = corner_radius;
  translate([0, 0, depth/2 + corner_radius])
    cube([length, width, chop_depth], center = true);
}

module shell() {
  difference() {
    shell_basis();
    shell_chop_off();
  }
}

module cup_hole() {
  hole_depth = depth + corner_radius;
  cube([length, width, hole_depth], center = true);
}

module ledge() {
  translate([0, 0, 0]) {
    cube([ledge_length, width, depth + corner_radius], center = true);
  }
}

module ledges() {
  translate([length/2 - ledge_length/2, 0, 0])
    ledge();
  translate([-length/2 + ledge_length/2, 0, 0])
    ledge();
}  

module screw_hole() {
  diameter = 4;
  translate([0, 0, 10]) {
    cylinder(h = 30, d = diameter, center = true);
  } 
}

module screw_holes() {
  width_inset = 7;
  length_inset = 3.5;
  x = length/2 - length_inset;
  y = width/2 - width_inset; 
  translate([x, y, 0]) { 
    screw_hole(); 
  }
  translate([x, -y,  0]) {
    screw_hole();
  }
  translate([-x, y, 0]) {
    screw_hole();
  }
  translate([-x, -y, 0]) {
    screw_hole();
  }
}

module nut_hole() {
  x1 = -3.5;
  y1 = 0;
  x2 = -1.75;
  y2 = 3;
  x3 = 1.75;
  y3 = 3;
  x4 = 3.5;
  y4 = 0;
  x5 = 1.75;
  y5 = -3;
  x6 = -1.75;
  y6 = -3;

  linear_extrude(height = 5, center = true) {
    polygon([[x1, y1], [x2,y2], [x3,y3], [x4,y4], [x5, y5], [x6, y6]]);
  }
}
  
module finger_hole() {
  translate([0, 0, -5]) {
    cube([16, 16, 10], center = true);
  }
}

module nut_holes() {
  width_inset = 6.5;
  length_inset = 3.5;
  x = length/2 - length_inset;
  y = width/2 - width_inset; 
  translate([x, y, 0]) { 
    nut_hole(); 
  }
  translate([x+3, y, 0]) {
    finger_hole(); 
  }
  translate([x, -y,  0]) {
    nut_hole();
  }
  translate([x+3, -y, 0]) {
    finger_hole(); 
  }
  translate([-x, y, 0]) {
    nut_hole();
  }
  translate([-(x+3), y, 0]) {
    finger_hole(); 
  }
  translate([-x, -y, 0]) {
    nut_hole();
  }
  translate([-(x+3), -y, 0]) {
      finger_hole(); 
  }
}
  
module main_cup_shape() {
  union() {
    difference() {
      shell();
      cup_hole();
      shell_chop_off();
    }
    ledges();
  }
}

difference() {
  main_cup_shape();
  screw_holes();
  nut_holes();
}
