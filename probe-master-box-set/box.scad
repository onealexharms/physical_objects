//width 108  length 172
//main and sharps, 50 or so by whole length
//alligators and forks, Right side remaining 58 x 60long

radius = 5;
width = 108;
length = 172;
height = 38;
wall = 1;

// +----+-------+
// | 1  | 2     |
// |    |       |
// |    +-------+
// |    | 3 | 4 |
// |    |   |   |
// |    |-------+
// |    | 5     |
// |    |       |
// +----+-------+

leads_and_sharps_width = 48; // 1
leads_and_sharps_length = 170;
alligators_and_forks_width = 57; // 2
alligators_and_forks_length = 59;
l_clamps_width = 28; // 3
l_clamps_length = 69;
thermistor_width = 28; // 4
thermistor_length = 69;
tiny_clamps_width = 57; // 5
tiny_clamps_length = 40;

module box() {
  difference() {
    round_bottom_box(width,length,height,radius);
    leads_and_sharps();
    alligators_and_forks();
    l_clamps();
    thermistor();
    tiny_clamps();
  }
}

module leads_and_sharps() {
  translate([wall,wall,wall]) {
    round_bottom_box(leads_and_sharps_width,leads_and_sharps_length,height,radius);
  }
}

module alligators_and_forks() {
  translate([wall + leads_and_sharps_width + wall, wall + tiny_clamps_length + wall + thermistor_length + wall, wall])
    round_bottom_box(alligators_and_forks_width, alligators_and_forks_length, height, radius);
}

module l_clamps() {
  translate([wall + leads_and_sharps_width + wall, wall + tiny_clamps_length + wall, wall])
    round_bottom_box(l_clamps_width, l_clamps_length, height, radius);
}

module thermistor() {
  translate([wall + leads_and_sharps_width + wall + l_clamps_width + wall, wall + tiny_clamps_length + wall, wall])
    round_bottom_box(thermistor_width, thermistor_length, height, radius);
}

module tiny_clamps() {
  translate([wall + leads_and_sharps_width + wall, wall, wall])
    round_bottom_box(tiny_clamps_width, tiny_clamps_length, height, radius);
}

module spheres(width,length,height,radius) {
  translate([radius,radius,radius]) sphere(radius);
  translate([width-radius, length-radius, radius]) sphere(radius);
  translate([width-radius, radius, radius]) sphere(radius);
  translate([radius, length-radius, radius]) sphere(radius);
}

module slicer(width,length,height) {
  translate([0,0,height]) cube([width, length, height]); 
}

module round_bottom_box(width, length, height,radius) {
  difference() {
    hull() {
      spheres(width,length,height,radius);
      translate([0,0,height]) spheres(width,length,height,radius);
    }
    slicer(width, length, height);
  }
}

box();
