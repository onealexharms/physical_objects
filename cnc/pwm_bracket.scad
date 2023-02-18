
rail_width = 20;
rail_distance = 54;
rail_slot_height = 6;

distance_between_mounting_holes = 54 + 20/2 + 20/2;

pcb_height = 33.5;
pcb_mounting_hole_distance = 13;

bracket_height = 54 + 20 + 20;
bracket_width = 20;

module bracket() {
  difference() {
    union() {
      cube([bracket_width, 2, bracket_height], center=true);
      for (z = [-1, 1]) {
        translate([0, 2/2, z*distance_between_mounting_holes/2])
        cube([bracket_width, 1.1, rail_slot_height-2], center=true);
      }
    }
    for (z = [-1, 1]) {
      translate([0, 0, z*distance_between_mounting_holes/2])
      rotate([90,0,0])
      cylinder(d=3.3, h=10, center=true, $fn=20);
    }
    for (x = [-1, 1]) {
      translate([x*pcb_mounting_hole_distance/2, 0, pcb_height/2 - 2])
      rotate([90,0,0])
      cylinder(d=2.2, h=10, center=true, $fn=20);
    }
    translate([0, -2/2 + 0.5, pcb_height/2 + 4/2 + 1.5])
    rotate([90,0,0])
    linear_extrude(0.51)
    text("-PWM+", size=3.5, halign="center", valign="center", font="Input Mono");
    
    translate([-bracket_width/2 + 4/2 + 1, -2/2 + 0.5, -pcb_height/2 - 4/2 - 8])
    rotate([90,-90,0])
    linear_extrude(0.51)
    text("+VIN-", size=3.5, halign="center", valign="center", font="Input Mono");
    
    translate([bracket_width/2 - 4/2 - 1, -2/2 + 0.5, -pcb_height/2 - 4/2 - 8])
    rotate([90,-90,0])
    linear_extrude(0.51)
    text("+VOUT-", size=3.5, halign="center", valign="center", font="Input Mono");
  }
}

bracket();
