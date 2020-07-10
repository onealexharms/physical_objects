include <../things/nib.scad>
include <../data/labels.data>

module cup(cup_width_in_nibs, cup_length_in_nibs, cup_depth = 25, label = true, split = false) {
  gap = 1;
  cup_base_thickness = 2;
  cup_wall_thickness = 1;
  cup_width = nib_center_distance * cup_width_in_nibs - (2 * gap);
  cup_length = nib_center_distance * cup_length_in_nibs - (2 * gap);

  module cup_base() {
    cube(size = [cup_length, cup_width, cup_depth]);
      translate([nib_buffer - 2 * gap, nib_buffer - 2 * gap, 0])
        nib_hole();
  }
  module nib_hole() {
    function hole_dimension(nib_count) =
      let(spaces_width = nib_buffer * ((nib_count * 2) - 2),
          nibs_width = nib_size * nib_count,
          margin = gap * 2)
      nibs_width + spaces_width + margin;
    length = hole_dimension(cup_length_in_nibs);
    width = hole_dimension(cup_width_in_nibs);
    depth = nib_height + gap;
    translate([(cup_length - length)/2, (cup_width - width)/2, 0])
      cube([length, width, depth]);
  }
  module cup_inside() {
    inside_width = cup_width - 2 * cup_wall_thickness;
    inside_length = cup_length - 2 * cup_wall_thickness;
    inside_depth = cup_depth;
    translate([cup_wall_thickness, cup_wall_thickness, cup_base_thickness + nib_height])
      cube([inside_length, inside_width, inside_depth]);
  }

  module label_wall() {
    module protrusion() {
      translate([0, 0, cup_depth])
        cube([(label_height * tan(30)), cup_width, 2]);
    }

    hull() {
      cube([cup_wall_thickness, cup_width, cup_depth + label_height]);
      protrusion();
    }
  }

  module hollow_cup() {
    difference() {
      union() {
        difference() {
          cup_base();
          cup_inside();
        }
        if (split)
          section_divider();
      }
      nib_hole();
    }
  }

  module divot() {
    finger_depth = 4;
    divot_margin = 2;
    divot_radius = 11;
    sphere_radius = pow(divot_radius,2)/8 + 2; 
    move_up = cup_depth + label_height - divot_radius - divot_margin;
    move_x = -(sphere_radius - finger_depth);
    translate([move_x, cup_width/2, move_up])
      sphere(r = sphere_radius);
  }

  module leg() {
    cube([0.5, 0.5 , 2]);
  }

  module tiny_legs() {
    //these are to make the printer use suport material as a raft
    x_extent = cup_width - cup_wall_thickness/2;
    y_extent = cup_length - cup_wall_thickness/2;
    z = -2; 
    
    translate([0, 0, z])
      leg();
    translate([y_extent, 0, z])
      leg();
    translate([0, x_extent, z])
      leg();
    translate([y_extent, x_extent, z])
      leg();
  }

  module section_divider() {
    y_position = cup_width / 2 - cup_wall_thickness / 2;
    translate([0, y_position, 0])
      cube([cup_length, cup_wall_thickness, cup_depth]);
  }

  module whole_thing() {
    if (label) {
      difference() {
        union() {
          hollow_cup();
          label_wall();
        }
        divot();
      } 
    } else {
      hollow_cup();
    }
  }
    
  whole_thing();
//  tiny_legs();
  
}
