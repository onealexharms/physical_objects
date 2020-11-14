thickness = 5;
bar_diameter = 8;
distance_between_bars = 53;
inside_ring_diameter = 59;
bar_length = inside_ring_diameter + 2*thickness;

module bar() {
  rotate([90, 0, 0]) cylinder(h=bar_length + 0.01, d=bar_diameter + 0.2, center=true);
}

module bars() {
    translate([-distance_between_bars/2 - bar_diameter/2, 0, 0]) bar();
    translate([+distance_between_bars/2 + bar_diameter/2, 0, 0]) bar();
}

module arm() {
    difference() {
        cube([bar_diameter + 2, bar_length, bar_diameter + 2], center=true);
        rotate([90, 0, 0]) cylinder(h=bar_length + 0.01, d=bar_diameter + 0.2, center=true);
    }
}

module arms() {
    translate([-distance_between_bars/2 - bar_diameter/2, 0, 0]) arm();
    translate([+distance_between_bars/2 + bar_diameter/2, 0, 0]) arm();
}

module ring() {
    difference() {
        cube([inside_ring_diameter + 2*thickness, inside_ring_diameter + 2*thickness, 10], center=true);
        cylinder(h=11, d=inside_ring_diameter, center=true);
        translate([0, -(inside_ring_diameter/2 + thickness), 0])
            cube([inside_ring_diameter + 2*thickness + 0.1, inside_ring_diameter + 2*thickness, 15], center=true);
    }
}

difference() {
    translate([0, 0, 5]) ring();
    bars();
}
arms();

