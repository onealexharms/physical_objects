thickness = 5;
bar_diameter = 9;
distance_between_bars = 53;
inside_ring_diameter = 62;
bar_l = 20;
bar_length = bar_l * 2; // mirrored
arm_length = bar_length + 2;
arm_offset = distance_between_bars/2 + bar_diameter/2;
arm_side = bar_diameter + 2;
outside_ring_diameter = 2*arm_offset + arm_side;
ring_height = arm_side + 2*thickness;
e = 0.01;

module bar() {
  module front_bar() {
    translate([0, -bar_l/2, 0])
      rotate([90, 0, 0]) cylinder(h = bar_l, d = bar_diameter, center=true);
  }
  module rear_bar() {
    translate([0, outside_ring_diameter/2/2, 0])
      rotate([90, 0, 0]) cylinder(h = outside_ring_diameter/2 + e, d = bar_diameter, center = true);
  }
  union() {
    front_bar();
    rear_bar();
  }
}

module bars() {
  translate([arm_offset, 0, 0])  bar();
  translate([-arm_offset, 0, 0]) bar();
}

module arm() {
  cube([arm_side, arm_length, arm_side], center=true);
}

module arms() {
  translate([arm_offset, 0, 0])  arm();
  translate([-arm_offset, 0, 0]) arm();
}

module ring_chopper() {
  translate([0, -(inside_ring_diameter/2 + thickness), 0])
    cube([outside_ring_diameter + e, inside_ring_diameter + 2*thickness, ring_height + e], center=true);
}

module ring_hole() {
  cylinder(h = ring_height + e, d=inside_ring_diameter, center=true);
}

module ring() {
  difference() {
    cylinder(h = ring_height, d = outside_ring_diameter, center = true);
    ring_chopper(); 
    ring_hole();
  }
}

module outer_contour() {
  difference() {
    cube([outside_ring_diameter + e, outside_ring_diameter, ring_height + e], center = true);
    cylinder(h = ring_height + 2*e, d = outside_ring_diameter, center = true);
    ring_chopper();
  }
}

difference() {
  union() {
    arms();
    ring();
  }
  bars();
  outer_contour();
}

