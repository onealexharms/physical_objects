module drawer_insert(drawer_length, drawer_width, drawer_height, drawer_lip_thickness) {
  floor_height = .6; //was 2
  include <../things/nib.scad>

  section_length = drawer_length / 2; //based on the size of the printer bed

//the side_rail_width is actually whatever it takes to make the drawer an even number of nibs.
//we really should be calculating that
  side_rail_width = 4.5;//honestly, it's calculated from what's needed to make a whole # of nibs
  
  number_of_nibs_wide = (drawer_width - 2*side_rail_width)/nib_center_distance;
  number_of_nibs_long = (section_length - drawer_lip_thickness)/nib_center_distance; 

  side_rail_height = drawer_height/2;
  
  tab_width_in_nibs = 1;
  tab_width = 2 * nib_buffer + (tab_width_in_nibs * nib_center_distance);
  tab_inset = side_rail_width + 1.5 * nib_center_distance;
  tab_tuck = 4;//(nib_buffer - 1) * 2;
  tab_length = nib_center_distance;


  module tab() {
    A = [0, tab_width/2 - tab_tuck];
    B = [tab_length, tab_width/2];
    C = [tab_length, -tab_width/2];
    D = [0, -tab_width/2 + tab_tuck];
    linear_extrude(floor_height) polygon([A,B,C,D]);
  }
  module plain_floor() {
    cube(size = [section_length, drawer_width, floor_height]);
  }
  module position_innie() {
    along_x = section_length;
    along_y = drawer_width - tab_inset;
    along_z = -0.5;
    translate([along_x, along_y, along_z]) 
      children();
  }
  module expand_innie() {
    newsize = [tab_length + 0.5, tab_width + 1, floor_height + nib_height];
    resize(newsize = newsize)
      children();
  }
  module flip_innie() {
    across_y_z_plane = [1, 0, 0];
    mirror(across_y_z_plane)
      children();
  }
  module innie_tab() {
    position_innie()
       flip_innie()
         expand_innie()
           tab();
  }
  module outie_tab() {
    position_outie() tab();
  }
  module position_outie() {
    along_x = section_length;
    along_y = tab_inset;
    along_z = 0;
    translate([along_x, along_y, along_z]) children();
  }
  module bottom() {
    difference() {
      plain_floor();
      innie_tab();
    }
    outie_tab();
  }
  module nibs() {
    color("red")
    for (i = [0 : number_of_nibs_long])
      for (j = [0 : number_of_nibs_wide])
        nib(i, j);
  }
  module drawer_lip() {
    difference() {
      cube(size = [drawer_lip_thickness, drawer_width, drawer_height]);
    }
  }
  module side_rail() {
    cube(size = [section_length, side_rail_width, side_rail_height]);
  }
  
  module middle_stupid_notch() {
    cube(size=[drawer_lip_thickness, 5, 5]);
  }
  
  module edge_stupid_notch() {
    cube(size=[drawer_lip_thickness, 2, drawer_height]);
  }

  module stupid_notches() {
    edge_stupid_notch();
    translate([0, drawer_width-2, 0])
      edge_stupid_notch() ;
    left_rivet=65;
    right_rivet=drawer_width-70;
    translate([0, left_rivet, 0])
      middle_stupid_notch();
    translate([0, right_rivet, 0])
      middle_stupid_notch();
  }

  difference() {
    union() {
      bottom();
      drawer_lip();
      side_rail();
      translate([0, drawer_width - side_rail_width, 0]) 
        side_rail();
      intersection() {
        scale([1, 1, 10]) bottom();
        nibs();
      }
    }
    stupid_notches();
  }
}
