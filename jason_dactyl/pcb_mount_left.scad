panel_hole_height=12;
panel_hole_width=29;
wall_thickness=4;

trrs_hole=8.5;
inner_wall_thickness=1.5;
panel_thin_part_inset=1;

difference() {
  cube([panel_hole_width, wall_thickness, panel_hole_height]);
  translate([panel_thin_part_inset, -0.1, panel_thin_part_inset])
    inset_hole();
}

module inset_hole() {
  inset_width = panel_hole_width - 2*panel_thin_part_inset;
  inset_thickness = wall_thickness - inner_wall_thickness + 0.1;
  inset_height = panel_hole_height - 2*panel_thin_part_inset;
  cube([inset_width, inset_thickness, inset_height]);
}
