module spheres(width,length,height,radius) {
  translate([radius,radius,radius]) sphere(radius);
  translate([width - radius, length - radius, radius]) sphere(radius);
  translate([width - radius, radius, radius]) sphere(radius);
  translate([radius, length - radius, radius]) sphere(radius);
}

module slicer(width, length, z_up, height) {
  translate([0, 0, z_up]) cube([width, length, height]); 
}

module round_bottom_box(width, length, height, radius) {
  difference() {
    hull() {
      spheres(width,length,height,radius);
      translate([0,0,height]) spheres(width,length,height,radius);
    }
    slicer(width, length, height+radius, radius+1);
  }
}

module hollow_round_bottom_box(width, length, height, radius, wall = 2) {
 inside_width = width - (2 * wall);
 inside_length = length - (2 * wall);
 inside_height = height;
 difference() {
   round_bottom_box(width, length, height, radius);
   translate ([wall, wall, wall]) 
     round_bottom_box(inside_width, inside_length, inside_height, radius);
 }
}

hollow_round_bottom_box(100,75,100,3,2);
