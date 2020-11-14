thickness = 5;
bar_diameter = 9;
distance_between_bars = 53;
inside_ring_diameter = 59;
bar_length = inside_ring_diameter + 2*thickness;
arm_offset = distance_between_bars/2 + bar_diameter/2;
arm_side = bar_diameter + 2;
outside_ring_diameter = 2*arm_offset + arm_side;
ring_height = arm_side + 2*thickness;
preview_hack = 1;

module bar() {
  rotate([90, 0, 0]) cylinder(h = bar_length + preview_hack, d = bar_diameter, center=true);
}

module bars() {
  translate([arm_offset, 0, 0])  bar();
  translate([-arm_offset, 0, 0]) bar();
}

module arm() {
  cube([arm_side, bar_length, arm_side], center=true);
}

module arms() {
  translate([arm_offset, 0, 0])  arm();
  translate([-arm_offset, 0, 0]) arm();
}

module ring_chopper() {
  translate([0, -(inside_ring_diameter/2 + thickness), 0])
    cube([outside_ring_diameter + preview_hack, inside_ring_diameter + 2*thickness, ring_height + preview_hack], center=true);
}

module ring_hole() {
  cylinder(h = ring_height + preview_hack, d=inside_ring_diameter, center=true);
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
    cube([outside_ring_diameter + preview_hack, outside_ring_diameter + preview_hack, ring_height + preview_hack], center = true);
    cylinder(h = ring_height + 2*preview_hack, d = outside_ring_diameter, center = true);
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

