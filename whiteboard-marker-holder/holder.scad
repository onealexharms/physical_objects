use <../../probe-master-box-set/box.scad>

thickness_of_board = 4;

x_depth = 20;
y_width = 80;
z_height = 90;
corner_radius = 5;
wall = 1;

lip_depth = 4 + wall;
lip_width = y_width - 2*corner_radius;
lip_height = 6;



inside_height = z_height - wall;
inside_depth = x_depth - 2*wall;
inside_width = y_width - 2*wall;

module lip() {
  translate([x_depth - wall, corner_radius, z_height-lip_height]) { 
    difference() {
      cube([lip_depth+wall, lip_width, lip_height]);
      cube([lip_depth, lip_width ,lip_height-wall]);    
    }
  }
}

module hole() {
  translate([wall, wall, wall]) {
    round_bottom_box(inside_depth, inside_width, z_height, corner_radius);
  }
}

union() {
  lip();
  difference() {
    round_bottom_box(x_depth, y_width, z_height, corner_radius);
    hole();
  }
}

