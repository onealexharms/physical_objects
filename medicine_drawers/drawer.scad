echo("----------------------------------------");
smidge = 0.2;
handle_length = 10;
handle_height = 3;
base_width = 37;
box_length = 74;
base_length = 84;
base_height = 2;

outer_width = base_width;
outer_length = base_length - handle_length;
outer_height = 35 - base_height;

inner_width = 32;
inner_length = 68;
inner_height = 32;

slot_thickness = 1;
slot_setback = 2;
slot_front_position = outer_length - slot_setback;
slot_side_margin = 2;
slot_width = outer_width - 2 * slot_side_margin;
slot_height = outer_height;

window_diameter = outer_width - 8;
edge_rounder_diameter = 8;

drawer();
//finger_hole();

module finger_hole() {
  diameter = 15;
  x = base_width/2;
  y = base_length - handle_length;
  z = -1;
  module vertical_chop() {
    translate([0, -diameter/2, 0]) {
      cube(diameter + smidge, center = true);     
    }
  }

  module top_chop() {
    translate([0, 0, diameter-3]) {
      cube(diameter + smidge, center = true);
    }
  }

  translate([x, y, z]) {
    color("purple") {
      cylinder(h = base_height*2, d = diameter);
    }
    color("blue") {
      vertical_chop();
    }
  }
}

module the_hollow() {
  bottom_z = edge_rounder_diameter/2+base_height-1;
  top_z = outer_height-edge_rounder_diameter/2 + 10;
  back_y =  edge_rounder_diameter/2;
  front_y =  outer_length-edge_rounder_diameter/2 - 1;
  hollow_x = 1;
  module back_bottom_edge() {
    translate([hollow_x, back_y+edge_rounder_diameter, bottom_z]) {
      edge_rounder();
    }
  }
  module back_top_edge() {
    translate([hollow_x, back_y, top_z]) {
      edge_rounder();
    }
  }
  module front_bottom_edge() {
    translate([hollow_x, front_y-edge_rounder_diameter*2, bottom_z]) {
      edge_rounder();
    }
  }
  module front_top_edge() {
    translate([hollow_x, front_y, top_z]) {
      edge_rounder();
    }
  }
  module edge_rounder() {
    rotate([0, 90, 0]) {
      cylinder(h=outer_width-2, d=edge_rounder_diameter);
    }
  }
  hull() {
  back_bottom_edge();
  back_top_edge();
  front_bottom_edge();
  front_top_edge();
  }
}

module drawer() {
  difference() {
    box();
    the_hollow(); 
    }
  difference() {
    base();
    finger_hole();
  }
}

module box() {
  difference() {
    cube([base_width, outer_length, outer_height]);
    label_slot();
    label_window();
  }
}

module base() {
  cube([base_width, base_length, base_height]);
}

module label_slot() {
  difference() {
  translate([slot_side_margin, slot_front_position, 1]) {
    cube([slot_width, slot_thickness, slot_height]);
    } 
  }
}

module label_window() {
  translate([base_width/2, outer_length+2, outer_height/2+1]) {
    rotate([90, 0, 0]) {
      cylinder(h=3, d=window_diameter);
    }
  }
}

module flat_sides_of_hollow() {
  translate([0, 0, inner_height]) {
    cube([inner_width, inner_length, inner_height/2]);
  }
}

module dirigible(radius) {
  translate([0, inner_length/2-radius, 0]) {
    sphere(radius);
  }
  translate([0, -inner_length/2+radius, 0]) {
    sphere(radius);
  }
}

module rounded_side_of_hollow() {
  hull() {
    dirigible(14);
    translate([0, 0, inner_height])
      dirigible(19);
  }
}
