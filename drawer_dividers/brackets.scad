wall_thickness = 1.5; // of walls
wood_thickness = 2;
smidge = .01;
spacing = 50;

length = 40;
width = 6;
height = 10;

gap_length = length + wall_thickness;
gap_width = wood_thickness + 0.5;
gap_height = height;

module gap(rotation) {
  rotate(rotation) {
    translate([0, 0, wall_thickness]) {
      cube([gap_length, gap_width, gap_height], center = true);
    }
  }
}

module segment(rotation) {
  rotate(rotation) {
    cube([length, width, height], center = true);
    }
  }

module gaps() {
  union() {
    gap(0);
    gap(90);
    }
  }

module segments() {
  union() {
    segment(0);
    segment(90);
    }
  }

module x_bracket() {
  difference() {
    segments();
    gaps();
    }
  }

module t_bracket() {
  difference() {
    x_bracket();
    translate([width/2 + smidge, -width, -height]) {
      cube([length, length, length]);
      }
    }
  }

module corner() {
  translate([gap_width/2 - smidge, gap_width/2 - smidge, -(height/2 - wall_thickness)]) {
    cube([wall_thickness + 1, wall_thickness + 1, height + 1]);
    }
  }

module l_bracket() {
  difference() {
    t_bracket(); 
    union() {
      translate([-width/2 - wall_thickness - smidge, width/2, - height + wall_thickness]) {
        cube([length, length, length]);
      }    
      %corner();
      }
    }
  }

x_bracket();

translate([50, 0, 0]) {
  t_bracket();
  }

translate([80, 0, 0]) {
  l_bracket();
  }
