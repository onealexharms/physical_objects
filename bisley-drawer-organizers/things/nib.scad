nib_center_distance = 25;
nib_size = 15;
nib_height = 2;
nib_buffer = (nib_center_distance - nib_size)/2;
 
function nib_hole_dimension(nib_count, gap) =
  let(spaces_width = nib_buffer * ((nib_count * 2) - 2),
      nibs_width = nib_size * nib_count,
      margin = gap * 2)
  nibs_width + spaces_width + margin;

module nib(i, j) {
  which_nib = i * nib_center_distance;
  along_x = drawer_lip_thickness + nib_buffer + which_nib;
  along_y = side_rail_width + nib_buffer + j*nib_center_distance;
  along_z = floor_height;
  translate([along_x, along_y, along_z])
     cube(size = [nib_size, nib_size, nib_height]);
}
