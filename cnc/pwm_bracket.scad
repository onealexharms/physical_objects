
rail_width = 20;
rail_distance = 54;

distance_between_mounting_holes = 54 + 20/2 + 20/2;

pcb_mounting_hole_z_distance = 45;
pcb_mounting_hole_x_distance = 65;

bracket_height = 54 + 20 + 20;
bracket_width = pcb_mounting_hole_x_distance + 10;
bracket_thickness = 3;

module bracket() {
  difference() {
    union() {
      cube([bracket_width, bracket_thickness, bracket_height], center=true);
    }
    for (z = [-1, 1]) {
      for (x = [-1, 1]) {
        translate([x*pcb_mounting_hole_x_distance/2, 0, z*distance_between_mounting_holes/2])
        rotate([90,0,0])
        cylinder(d=3.3, h=10, center=true, $fn=20);
      }
    }
    for (x = [-1, 1]) {
      for (z = [-1, 1]) {
        translate([x*pcb_mounting_hole_x_distance/2, 0, z*pcb_mounting_hole_z_distance/2])
        rotate([90,0,0])
        cylinder(d=2.2, h=10, center=true, $fn=20);
      }
    }
  }
}

projection()
rotate([90,0,0])
bracket();
