panel_hole_height=12;
panel_hole_width=29;
wall_thickness=1.75;

trrs_hole_diameter=8.5;
usbc_height = 3.15;
usbc_width = 8.92;
usbc_depth = 7.32;

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

module usbc_port() {
  module roundy_thingy() { 
    translate([-(usbc_width - usbc_height) / 2, 0, 0])
      cylinder(h = usbc_depth, d = usbc_height, $fn = 10);
    translate([(usbc_width - usbc_height) / 2, 0, 0])
      cylinder(h = usbc_depth, d = usbc_height, $fn = 10);
    translate([-(usbc_width - usbc_height)/2, -usbc_height / 2, 0])
      cube([usbc_width - usbc_height, usbc_height, usbc_depth]);
  }
  difference() {
    roundy_thingy();
    translate([0, 0, -0.2])
      scale([0.9, 0.8, 1.5])
        roundy_thingy();
  }
}

module elite_c() {
  port_color = [0.9, 0.9, 0.9];
  body_color = [11/256, 57/256, 39/256];
  width = 18.55;
  color(body_color) cube([width, 33.1, 0.98]);
  translate([width/2, -1, -usbc_height/2])
    rotate([-90, 0, 0])
      color(port_color)
        usbc_port();
}

translate([21,-11.5,panel_hole_height / 2])
  rotate([-90,0,0])
    trrs_plug();
translate([0, wall_thickness, 0])
  elite_c();
