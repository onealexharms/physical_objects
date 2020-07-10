use <../utility/round-bottom-box.scad>

alex_drawer_width = 290;

radius = 2;
width = alex_drawer_width/2;
length = 120;
height = 50;
wall = 1;

// +-------+------+------+
// | large | sm_1 | sm_2 | 
// |       |      |      |
// |       +-------------+
// |       | med  | med  |
// |       |      |      |
// |       |      |      |
// +-------+------+------+

large_width = 55;
large_length = length - 2*wall;

small_1_width = 45 - 2*wall;
small_length = 40 - wall;

medium_1_width = small_1_width;
medium_length = length - 2*wall - small_length - wall;

small_2_width = width - large_width - small_1_width - 4*wall;

medium_2_width = small_2_width;

second_column_x = wall + large_width + wall;
third_column_x = wall + large_width + wall + small_1_width + wall;

second_row_y = wall + small_length + wall;

module box() {
  difference() {
    round_bottom_box(width,length,height,radius);
    large();
    small_1();
    medium_1();
    small_2();
    medium_2();
  }
}

module large() {
  translate([wall, wall ,wall]) 
    round_bottom_box(large_width, large_length, height, radius);
}

module medium_1() {
  translate([second_column_x, second_row_y, wall])
    round_bottom_box(medium_1_width, medium_length, height, radius);
}

module small_1() {
  translate([second_column_x, wall, wall])
    round_bottom_box(small_1_width, small_length, height, radius);
}

module small_2() {
  translate([wall + large_width + wall + small_1_width + wall, wall, wall])
    round_bottom_box(small_1_width, small_length, height, radius);
}

module medium_2() {
  translate([third_column_x, second_row_y, wall])
    round_bottom_box(medium_1_width, medium_length, height, radius);
}

box();
