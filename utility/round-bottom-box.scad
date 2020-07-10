module spheres(width,length,height,radius) {
  translate([radius,radius,radius]) sphere(radius);
  translate([width-radius, length-radius, radius]) sphere(radius);
  translate([width-radius, radius, radius]) sphere(radius);
  translate([radius, length-radius, radius]) sphere(radius);
}

module slicer(width,length,height) {
  translate([0,0,height]) cube([width, length, height]); 
}

module round_bottom_box(width, length, height, radius) {
  difference() {
    hull() {
      spheres(width,length,height,radius);
      translate([0,0,height]) spheres(width,length,height,radius);
    }
    slicer(width, length, height);
  }
}
