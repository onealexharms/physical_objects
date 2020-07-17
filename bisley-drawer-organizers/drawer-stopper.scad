include <data/bisley-5-drawer-cabinet.data>

stopper_depth = drawer_height - 10;
stopper_height = stopper_depth + top_drawer_space_above;
stopper_length = 20;
wall_thickness = drawer_wall_thickness;
stopper_thickness = drawer_wall_thickness*3;
stopper_tab_size = drawer_lip_thickness + stopper_thickness;

module stopper_tab()
{
  difference()
  {
    cube([stopper_tab_size,stopper_tab_size,stopper_height]);
      translate([-wall_thickness, wall_thickness, -wall_thickness])
      cube([stopper_tab_size,stopper_tab_size,stopper_height+2]);
  }
}

module drawer_stopper()
{
  translate([0,20,0])
  {
    difference() 
    {
      cube([stopper_length, stopper_thickness, stopper_height]);
      translate([0,drawer_wall_thickness,0])
        cube([stopper_length, drawer_wall_thickness, stopper_depth]);
    }

    translate([stopper_length, 0, 0])
    {
      stopper_tab();
    }

  }
}

drawer_stopper();
mirror([0,1,0])
  drawer_stopper();
