$fn = 50;

bearing_id = 8;
bearing_od = 22;
bearing_width = 7;

blade_width = 0.025 * 25.4;
blade_gap   = 1/32 * 25.4;

backstop_travel = 1/2 * 25.4;
backstop_position = 0.6;  // 0-1

washer_thickness = 1/16 * 25.4;

module bored_cylinder(id, od, h) {
  difference() {
    cylinder(d=od, h=h);
    translate([0,0,-0.1]) cylinder(d=id, h=h+0.2);
  }
}

module bearing() {
  bored_cylinder(id=bearing_id, od=12.4, h=bearing_width);
  bored_cylinder(id=18, od=bearing_od, h=bearing_width);
  
  translate([0,0,0.5])
  color("black")
  bored_cylinder(id=bearing_id+0.1, od=bearing_od-0.1, h=bearing_width-1);
}
  
module main_body() {
  front_depth = 3/8*25.4;
  main_body_depth = backstop_travel + bearing_id + 2*7;

  translate([0, bearing_width + front_depth/2, 0])
  cube([2*bearing_od + 2*blade_gap + blade_width, front_depth, bearing_od],center=true);

  riser_width = 3/8*25.4;
  
  difference() {
  
    translate([-riser_width/2 - washer_thickness - bearing_width/2, main_body_depth/2, bearing_od])
    cube([riser_width, main_body_depth, bearing_od], center=true);
    
    hull()
    for (position = [0, 1]) {
      translate([-washer_thickness - bearing_width/2 + 0.1, bearing_od/2 + position*backstop_travel, bearing_od])
      rotate([0,-90,0])
      cylinder(d=bearing_id, h=riser_width + 0.2);
    }
  }
  
}

module assembly() {
  translate([-bearing_od/2 - blade_gap - blade_width/2, 0, 0])
  rotate([-90,0,0])
  bearing();

  translate([+bearing_od/2 + blade_gap + blade_width/2, 0, 0])
  rotate([-90,0,0])
  bearing();

  translate([bearing_width/2, bearing_od/2 + backstop_travel*backstop_position, bearing_od])
  rotate([0,-90,0])
  bearing();

  translate([0, 2, 0])
  cube([blade_width, 3/8 * 25.4, 100], center=true);

  main_body();
}

assembly();
