use <../utility/round-bottom-box.scad>

alex_drawer_width = 290;

radius = 2;
width = alex_drawer_width/2;
length = 120;
height = 50;
wall = 1;

// +--------------+-------+
// | large        | small | 
// |              |       |
// |              |       |
// |              |       |
// |              |       |
// |              |       |
// +-------+------+-------+

large_width = 90;
large_length = length - 2*wall;

small_width = width - large_width - 3*wall;
small_length = large_length;

second_column_x = wall + large_width + wall;

module box() {
  difference() {
    round_bottom_box(width,length,height,radius);
    large();
    small();
  }
}

module large() {
  translate([wall, wall ,wall]) 
    round_bottom_box(large_width, large_length, height, radius);
}

module small() {
  translate([second_column_x, wall, wall])
    round_bottom_box(small_width, small_length, height, radius);
}

box();
