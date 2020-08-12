// you may be wondering what a stripper ring is.
// it's a ring to hold a pair of wire strippers (or pliers, whatever) closed while they're in a drawer

height = 30;
z = height/2;
radius = 10;
bottom_width = 20;
top_width = 15;
erase_plate_xy = bottom_width+4*radius;

module shell() {
  hull() {
    translate([0,top_width,z]) sphere(radius);
    translate([0,bottom_width,-z]) sphere(radius);
    translate([0,-bottom_width,-z]) sphere(radius);
    translate([0,-top_width,z]) sphere(radius);
  }
}

module shell_hole() {
  hull() {
    translate([0,top_width,z]) sphere(radius-1);
    translate([0,bottom_width,-z]) sphere(radius-1);
    translate([0,-bottom_width,-z]) sphere(radius-1);
    translate([0,-top_width,z]) sphere(radius-1);
  }
}

difference() {
  shell();
  shell_hole();
  translate([0,0,height-radius]) cube([erase_plate_xy,erase_plate_xy,radius], center=true);
  translate([0,0,-height+radius]) cube([erase_plate_xy,erase_plate_xy,radius], center=true);
}
