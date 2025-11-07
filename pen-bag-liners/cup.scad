use <../utility/round-bottom-box.scad>

smidge = 1;
bottom_width = 75;
bottom_depth = 37;
height = 90;
bottom_thickness = 2; 
bottom_radius = 3;
wall_thickness = 0.5;
inside_width = bottom_width - 2*wall_thickness;
inside_depth = bottom_depth - 2*wall_thickness;
radius = bottom_width/2;
inside_radius = radius - 2*wall_thickness;

module outside() {
  hull() {
    translate([radius,radius/2,height]) {
      cylinder(10,radius,radius);
      }
    round_bottom_box(bottom_width,bottom_depth,0,bottom_radius);
  }
}

module inside() {
  color("red") {
    translate ([wall_thickness/2,wall_thickness/2,bottom_thickness]) {
      hull() {
        translate([bottom_width/2-wall_thickness/2,bottom_depth/2-wall_thickness/2,height+wall_thickness]) {
          cylinder(10,inside_radius,inside_radius);
          }
        round_bottom_box(inside_width, inside_depth, 3, bottom_radius);
      }
    }
  }
}
difference() {
  outside();
  inside();
}
