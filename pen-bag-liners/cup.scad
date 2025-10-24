width = 75;
depth = 37;
height = 3;
bottom_thickness = 2; 
wall_thickness = 1;
hole_width = width - 2*wall_thickness;
hole_depth = depth - 2*wall_thickness;
difference() {
  cube([width, depth, height]);
  translate([wall_thickness,wall_thickness,bottom_thickness]) { 
    cube([hole_width, hole_depth, height]);
}}
