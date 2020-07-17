include <bisley-drawer-organizers/data/bisley-5-drawer-cabinet.data>

stopper_depth = drawer_height - 10;
stopper_height = stopper_depth + top_drawer_space_above;
stopper_width = drawer_width - 20;
stopper_thickness = 6;

difference() 
{
  cube([stopper_width, stopper_thickness, stopper_height]);
  translate([0,2,0])
    cube([stopper_width, drawer_wall_thickness, stopper_depth]);
}
