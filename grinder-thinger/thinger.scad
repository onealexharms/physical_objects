thickness = 5;
bar_diameter = 9;
distance_between_bars = 53;
inside_ring_diameter = 59;
bar_length = inside_ring_diameter + 2*thickness;
arm_offset = distance_between_bars/2 + bar_diameter/2;
arm_side = bar_diameter + 2;

module bar() {
  rotate([90, 0, 0]) cylinder(h=bar_length + 0.01, d=bar_diameter + 0.2, center=true);
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

module ring() {
    difference() {
        cube([bar_length, bar_length, 10], center=true);
        cylinder(h=11, d=inside_ring_diameter, center=true);
        translate([0, -(inside_ring_diameter/2 + thickness), 0])
            cube([inside_ring_diameter + 2*thickness + 0.1, inside_ring_diameter + 2*thickness, 15], center=true);
    }
}

difference() {
    union() {
      arms();
      translate([0, 0, 5]) ring();
    }
    bars();
}
