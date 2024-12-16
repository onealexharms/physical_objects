drawer_width = 647;
drawer_height = 370;
base_x = drawer_width/3;
base_y = drawer_height/2;
base_thickness = 10;
base_floor = 2; 
depth = base_thickness - base_floor;
small_bottle_diameter = 32;
medium_bottle_diameter = 37;

bottom_margin = 5;
spacing_y = 5;

medium_bottle_spacing_y = spacing_y + medium_bottle_diameter/2;
medium_spacing = (base_x - 4*medium_bottle_diameter)/5;
medium_bottle_y2 = medium_bottle_diameter + 2*spacing_y;

small_bottle_y = medium_bottle_y2 + spacing_y*3 + medium_bottle_diameter + small_bottle_diameter/2;
small_bottle_spacing_y = (base_x - 5*small_bottle_diameter)/6;
small_bottle_y2 = small_bottle_diameter+spacing_y;

difference() {
  cube([base_x,base_y,base_thickness]);
  medium_bottles();
  small_bottles();
}

function small_bottle_x(bottle_number) =
  small_bottle_spacing_y+
  small_bottle_diameter/2+
  (small_bottle_spacing_y+small_bottle_diameter)*bottle_number;

module small_bottles() {
  translate([small_bottle_x(0),small_bottle_y,0]) { 
    small_bottle_pair();
  }
  translate([small_bottle_x(1),small_bottle_y,0]) {
    small_bottle_pair();
  }
  translate([small_bottle_x(2),small_bottle_y,0]) {
    small_bottle_pair();
  }
  translate([small_bottle_x(3),small_bottle_y,0]) {
    small_bottle_pair();
  }
  translate([small_bottle_x(4),small_bottle_y,0]) {
    small_bottle_pair();
  }
}

module small_bottle_pair() {
  color("orange") {
    translate([0,0,2]) {
    cylinder(h=10, d=small_bottle_diameter);
    }
    translate([0,small_bottle_y2,2]) {
    cylinder(h=10, d=small_bottle_diameter);
    }
  }
}

function medium_bottle_x(bottle_number) = (medium_spacing+medium_bottle_diameter/2)+(medium_spacing+(medium_bottle_diameter))*bottle_number;

module medium_bottles() {
  translate([medium_bottle_x(0),medium_bottle_spacing_y,0]) {
    medium_bottle_pair();
  }
  translate([medium_bottle_x(1),medium_bottle_spacing_y,0]) {
    medium_bottle_pair();
  }
  translate([medium_bottle_x(2),medium_bottle_spacing_y,0]) {
    medium_bottle_pair();
  }
  translate([medium_bottle_x(3),medium_bottle_spacing_y,0]) {
    medium_bottle_pair();
  }
}

module medium_bottle_pair() {
  color("purple") {
    translate([0,0,2]) {
      cylinder(h=10, d=medium_bottle_diameter);
      }
    }
  color("blue") {
    translate([0,medium_bottle_y2,2]) {
      cylinder(h=10, d=medium_bottle_diameter);
    }
  }
}
