panel_hole_height=12;
panel_hole_width=29;
wall_thickness=1.75;

trrs_hole_diameter=8.5;

difference() {
  cube([panel_hole_width, wall_thickness, panel_hole_height]);
  trrs_hole();
}

module trrs_hole() {
  translate([21, wall_thickness + 0.1, panel_hole_height / 2])
    rotate([90, 0, 0])
      cylinder(h = 2*wall_thickness, d=trrs_hole_diameter);
}

module trrs_plug() {
  body_color = [0.15, 0.15, 0.15];
  nut_color = [0.8, 0.8, 0.8];
  flange_width = 1.5;
  flange_offset = 10;
  module flange() {
    translate([0, 0, flange_offset])
      cylinder(h = flange_width, d = 9.85);
  }
  module barrel() {
    cylinder(h = 11, d = 8);
  }
  module threads() {
      cylinder(h = 16, d = 7.65);
  }
  module plug_hole() {
    cylinder(h = 18, d = 3.5);
  }
  module nut() {
    translate([0, 0, flange_offset + flange_width + wall_thickness + 0.1])
      color([0.9,0.9,0.9])
        cylinder(h = 2, d = 10.76, $fn = 6);
  }

  difference() {
    union() {
      color(body_color) barrel();
      color(body_color) threads();
      color(body_color) flange();
      color(nut_color) nut();
    }
    plug_hole();
  }
}

translate([21,-11.5,panel_hole_height / 2])
  rotate([-90,0,0])
    trrs_plug();
