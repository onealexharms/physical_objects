outer_width = 35;
outer_length = 78;
outer_height = 35;

inner_width = 32;
inner_length = 68;
inner_height = 32;

label_depth = 4;
handle_depth = 88;

module label_slot() {
  difference() {
  translate([0, inner_length/2+3, 3]) {
    cube([outer_width-2, 1, 41], center=true);
    }
  }
}

module box() {
  difference() {
  minkowski() {
    cube([outer_width, outer_length, outer_height], center=true);
    sphere(2);
    }
  label_slot() {
    }
  }
}

module label_window() {
  translate([0, outer_length/2+5, 0]) {
    rotate([90, 0, 0]) {
      cylinder(h=7, r=15);
    }
  }
}

module flat_sides_of_hollow() {
  translate([0, 0, inner_height]) {
    cube([inner_width, inner_length, inner_height/2], center=true);
  }
}

module dirigible(radius) {
  translate([0, inner_length/2-radius, 0]) {
    sphere(radius);
  }
  translate([0, -inner_length/2+radius, 0]) {
    sphere(radius);
  }
}

module rounded_side_of_hollow() {
  hull() {
    dirigible(14);
    translate([0, 0, inner_height])
      dirigible(19);
  }
}

module handle() {
  rotate(a=[0, 0, 0]) {
    translate([0, 6, -outer_width/2]) {
      cube([outer_width, handle_depth, 3], center=true);
    }
  }
}

difference() {
  union() {
    box();
    handle();
  }
  flat_sides_of_hollow();
  rounded_side_of_hollow();
  label_window();
}
