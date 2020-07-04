use <../../probe-master-box-set/box.scad>

thickness_of_board = 4;

z_height = 72;
x_depth = 22;
y_width = 100;

lip_height = 72;
wall = 1;

inside_height = z_height - wall;
inside_depth = x_depth - 2*wall;
inside_width = y_width - 2*wall;

module hole() {
  translate([wall, wall, wall]) {
    round_bottom_box(inside_depth, inside_width, z_height, 5);
  }
}

difference() {
  round_bottom_box(x_depth, y_width, z_height, 5);
  hole();
  }
