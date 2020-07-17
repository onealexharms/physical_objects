module shell() {
  hull() {
    translate([0,11,10]) sphere(10);
    translate([0,15,-10]) sphere(10);
    translate([0,-15,-10]) sphere(10);
    translate([0,-11,10]) sphere(10);
  }
}

module shell_hole() {
  hull() {
    translate([0,11,10]) sphere(9.5);
    translate([0,15,-10]) sphere(9.5);
    translate([0,-15,-10]) sphere(9.5);
    translate([0,-11,10]) sphere(9.5);
  }
}


difference() {
  difference() {
    shell();
    translate([0,0,55]) cube(100, center=true);
    translate([0,0,-55]) cube(100, center=true);
  }

  difference() {
    shell_hole();
  }
}
