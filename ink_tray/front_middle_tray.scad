base_x = 275;
base_y = 215;
base_thickness = 10;

depth = 8; 

small_bottle_diameter = 32;
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

medium_bottle_spacing_y = 1.5*spacing_y + big_bottle_y + medium_bottle_diameter;

small_y_row1 = spacing_y + big_bottle_y + spacing_y + medium_bottle_diameter + spacing_y + small_bottle_diameter;
small_y_row2 = small_y_row1 + spacing_y + small_bottle_diameter;

medium_spacing_x= (base_x - medium_bottle_qty * medium_bottle_diameter)/(medium_bottle_qty+1);

module base() {
  cube([base_x,base_y,base_thickness]);
}

function small_bottle_x(bottle_number) = (small_spacing_x + small_bottle_diameter/2)+(small_spacing_x + small_bottle_diameter)*bottle_number;

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
    translate([medium_bottle_x(number), medium_bottle_spacing_y, 2]) {
      cylinder(h=10, d=medium_bottle_diameter);
    }
  }
}

function medium_bottle_x(bottle_number) = (medium_spacing_x + medium_bottle_diameter/2) + (medium_spacing_x + (medium_bottle_diameter))*bottle_number;

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

split_bottom_width = 162;
split_bottom_height = 135;
split_top_width = 177;
split_top_height = 110;
end_of_split = 300;
height_of_split = 12;

module left_split() {
  color("pink") {
    translate([-1,-1,-1]) {
      cube([split_bottom_width, split_bottom_height,height_of_split]); 
    }
  }
  color("purple") {
    translate([0,split_bottom_height-2,-1]) {
      cube([split_top_width, split_top_height,height_of_split]);
    }  
  }
}

module right_split() {
  translate([split_bottom_width-1,-2,-1]) {
    cube([split_bottom_width, split_bottom_height,height_of_split]); 
  }

  translate([split_top_width,split_bottom_height-2,-1]) {
    cube([split_top_width, split_top_height,height_of_split]);
  }  
}

module left() {
  difference() {
    color("blue") {
      base();
    }
    union() {
      big_bottles();
      medium_bottles();
      small_bottles();
    right_split();
    }
  }
}

module right() {
  difference() {
    color("white") {
      base();
    }
    union() {
      big_bottles();
      medium_bottles();
      small_bottles();
    left_split();
    }
  }
}
left();
