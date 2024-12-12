base_x = 275;
base_y = 215;
base_thickness = 10;

depth = 8; 

small_bottle_diameter = 31;
medium_bottle_diameter = 37;
big_bottle_x = 35;
big_bottle_y = 53;
bottom_margin = 5;
spacing_y = 10;
small_bottle_qty = 6;
medium_bottle_qty = 5;
big_bottle_qty = 5;

small_spacing_x = (base_x - (small_bottle_qty*small_bottle_diameter))/(small_bottle_qty + 1);
big_bottle_spacing_x = (base_x - (big_bottle_qty*big_bottle_x))/(big_bottle_qty + 1);

medium_bottle_spacing_y = 2*spacing_y + big_bottle_y + medium_bottle_diameter/2;
small_y_row1 = spacing_y + big_bottle_y + spacing_y + medium_bottle_diameter + spacing_y + small_bottle_diameter/2;
small_y_row2 = small_y_row1 + spacing_y + small_bottle_diameter;

medium_spacing = (base_x - medium_bottle_qty*medium_bottle_diameter)/(medium_bottle_qty+1);

function small_bottle_x(bottle_number) = (small_spacing_x + small_bottle_diameter/2)+(small_spacing_x + small_bottle_diameter)*bottle_number;

difference() {
  cube([base_x,base_y,10]);
  big_bottles();
  medium_bottles();
  small_bottles();
}

module small_bottles() {
    small_bottle_pair(0);
    small_bottle_pair(1);
    small_bottle_pair(2);
    small_bottle_pair(3);
    small_bottle_pair(4);
    small_bottle_pair(5);
  }

module small_bottle_pair(bottle_number) {
  color("orange") {
    translate([small_bottle_x(bottle_number),small_y_row1,2]){
    cylinder(h=10, d=small_bottle_diameter);
    }
    translate([small_bottle_x(bottle_number),small_y_row2,2]){
      cylinder(h=10, d=small_bottle_diameter);
    }
  }
}

module medium_bottle(number) {
  color("purple") {
    translate([medium_bottle_x(number),medium_bottle_spacing_y,2]) {
      cylinder(h=10, d=medium_bottle_diameter);
    }
  }
}

function medium_bottle_x(bottle_number) = (medium_spacing+medium_bottle_diameter/2)+(medium_spacing+(medium_bottle_diameter))*bottle_number;

module medium_bottles() {
  medium_bottle(0);
  medium_bottle(1);
  medium_bottle(2);
  medium_bottle(3);
  medium_bottle(4);
} 

module big_bottles() {
  big_bottle(0);
  big_bottle(1);
  big_bottle(2);
  big_bottle(3);
  big_bottle(4);
}

module big_bottle(number) {
  translate([(number*big_bottle_x)+(number+1)*(big_bottle_spacing_x),bottom_margin,3.1]) {
    cube([big_bottle_x,big_bottle_y,depth]);  
  }
}
