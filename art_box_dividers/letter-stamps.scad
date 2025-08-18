section = 13;
rows = 4;
columns = 10;
height = 27;
wall = 1;
outer_wall = wall * 2;
stamp_hole = section - (2*wall);
floor_thickness = 2;

module stamp_hole(row,col) {
  translate([row*section+wall,col*section+wall,floor_thickness]) {
    cube([stamp_hole,stamp_hole,height]);
  }
}

module outside_of_section() {
 cube([section,section,height]);
}

module inside_of_section() {
  translate([wall,wall,floor_thickness]) {
    cube([stamp_hole,stamp_hole,height]);
  }
}

difference() {
  cube([section*columns+outer_wall,section*rows+outer_wall,height]);
    translate([wall,wall,0]) {
    stamp_hole(0,0);
    stamp_hole(1,0);
    stamp_hole(2,0);
    stamp_hole(3,0);
    stamp_hole(4,0);
    stamp_hole(5,0);
    stamp_hole(6,0);
    stamp_hole(7,0);
    stamp_hole(8,0);
    stamp_hole(9,0);
    stamp_hole(10,0);

    stamp_hole(0,1);
    stamp_hole(1,1);
    stamp_hole(2,1);
    stamp_hole(3,1);
    stamp_hole(4,1);
    stamp_hole(5,1);
    stamp_hole(6,1);
    stamp_hole(7,1);
    stamp_hole(8,1);
    stamp_hole(9,1);
    stamp_hole(10,1);

    stamp_hole(0,2);
    stamp_hole(1,2);
    stamp_hole(2,2);
    stamp_hole(3,2);
    stamp_hole(4,2);
    stamp_hole(5,2);
    stamp_hole(6,2);
    stamp_hole(7,2);
    stamp_hole(8,2);
    stamp_hole(9,2);
    stamp_hole(10,2);
    
    stamp_hole(0,3);
    stamp_hole(1,3);
    stamp_hole(2,3);
    stamp_hole(3,3);
    stamp_hole(4,3);
    stamp_hole(5,3);
    stamp_hole(6,3);
    stamp_hole(7,3);
    stamp_hole(8,3);
    stamp_hole(9,3);
    stamp_hole(10,3);
  };
};

