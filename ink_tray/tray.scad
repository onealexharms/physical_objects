//six base plates for a drawer
base_x = 185;
base_y = 215;
base_z = 10;
big_bottle_x = 40;
big_bottle_y = 65;
big_bottle_z = 7; 
big_bottle_spacing_x = (base_x - (3*big_bottle_x))/4;
spacing_y = 10;
medium_bottle_diameter = 37;
medium_bottle_y = 6 + big_bottle_y+(2*spacing_y+medium_bottle_diameter/2);
medium_spacing = (base_x - 4*medium_bottle_diameter)/5;
small_bottle_diameter = 31;
small_bottle_y = medium_bottle_y+medium_bottle_diameter+spacing_y-6;
small_bottle_spacing = (base_x - 5*small_bottle_diameter)/6;
small_bottle_y2 = small_bottle_diameter+spacing_y;

function medium_bottle_x(bottle_number) = (medium_spacing+medium_bottle_diameter/2)+(medium_spacing+(medium_bottle_diameter))*bottle_number;

function small_bottle_x(bottle_number) = (small_bottle_spacing+small_bottle_diameter/2)+(small_bottle_spacing+(small_bottle_diameter))*bottle_number;

difference() {
  cube([185,215,10]);
  big_bottles();
  medium_bottles();
  small_bottles();
}

module small_bottles() {
  translate([small_bottle_x(0),small_bottle_y,0]) { 
    small_bottle();
    small_bottle_2();
  }
  translate([small_bottle_x(1),small_bottle_y,0]) {
    small_bottle();
    small_bottle_2();
  }
  translate([small_bottle_x(2),small_bottle_y,0]) {
    small_bottle();
    small_bottle_2();
  }
  translate([small_bottle_x(3),small_bottle_y,0]) {
    small_bottle();
    small_bottle_2();
  }
  translate([small_bottle_x(4),small_bottle_y,0]) {
    small_bottle();
    small_bottle_2();
  }
}

module small_bottle() {
  color("orange") {
    translate([0,0,2]) {
    cylinder(h=10, d=small_bottle_diameter);
    }
  }
}

module small_bottle_2() {
  color("pink") {
    translate([0,small_bottle_y2,2]) {
    cylinder(h=10, d=small_bottle_diameter);
    }
  }
}

module medium_bottles() {
  translate([medium_bottle_x(0),medium_bottle_y,0]) {
    medium_bottle();
  }
  translate([medium_bottle_x(1),medium_bottle_y,0]) {
    medium_bottle();
  }
  translate([medium_bottle_x(2),medium_bottle_y,0]) {
    medium_bottle();
  }
  translate([medium_bottle_x(3),medium_bottle_y,0]) {
    medium_bottle();
  }
}

module medium_bottle() {
  color("purple") {
    translate([0,0,2]) {
      cylinder(h=10, d=medium_bottle_diameter);
      }
    }
  }

module big_bottles() {
  translate([big_bottle_spacing_x,spacing_y,0]) {
    big_bottle();
  }
  translate([big_bottle_x+(2*big_bottle_spacing_x),spacing_y,0]) {
    big_bottle();
  }
  translate([(3*big_bottle_spacing_x)+(2*big_bottle_x),spacing_y,0]) {
    big_bottle();
  }
}

module big_bottle() {
  color("green") {
    translate([0,0,3.1]) {
    cube([big_bottle_x,big_bottle_y,big_bottle_z]);  
    }
  }
}
