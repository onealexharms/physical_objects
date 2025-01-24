$fn = 50;

microswitch_body_width = 20;
microswitch_body_height = 10;
microswitch_body_thickness = 6.5;

microswitch_relaxed_wheel_height = 19.5;
microswitch_triggered_wheel_height = 18.2;
microswitch_compressed_wheel_height = 15.4;
microswitch_roller_diameter = 5; //4.65;
microswitch_roller_x = 21.5/2 + 1 - microswitch_roller_diameter/2;

microswitch_hole_diameter = 2.56;
microswitch_hole_distance_from_edge = 4.0 + microswitch_hole_diameter/2;
microswitch_hole_distance_from_bottom = 1.6 + microswitch_hole_diameter/2;
wall_thickness = 3;

filament_diameter = 2.85;
filament_tolerance = 0.45;

ptfe_diameter = 4;
ptfe_insertion_length = 2;

body_width = microswitch_body_width + 2*wall_thickness;
body_height = microswitch_triggered_wheel_height + filament_diameter/2 + wall_thickness;
filament_y = microswitch_triggered_wheel_height;
body_thickness = wall_thickness + microswitch_body_thickness;

module microswitch_body() {
  translate([
    0,
    microswitch_body_height/2,
    0,
  ])
  cube([
    microswitch_body_width,
    microswitch_body_height,
    microswitch_body_thickness
  ], center=true);
}

module microswitch_positioning_pins() {
  for (x = [
    -microswitch_body_width/2 + microswitch_hole_distance_from_edge,
    +microswitch_body_width/2 - microswitch_hole_distance_from_edge,
  ])
  translate([
    x,
    microswitch_hole_distance_from_bottom,
    -wall_thickness/2
  ])
  cylinder(
    d=microswitch_hole_diameter - 0.5,
    h=4,
    $fn=50,
    center=true
  );
}

module filament_path() {
  translate([0, filament_y, 0])
  rotate([0,90,0])
  union() {
    cylinder(
      d=filament_diameter + filament_tolerance,
      h=microswitch_body_width+2*wall_thickness+1,
      center=true
    );
    
    translate([-filament_diameter,0,0])
    cube([
      2*filament_diameter,
      filament_diameter/3,
      microswitch_body_width+2*wall_thickness+1
    ], center=true);
  }
}

module roller_path() {
  length = filament_y - microswitch_body_height + 0.1;

  translate([
    microswitch_roller_x,
    filament_y - length/2,
    0,
  ])
  cube([
    microswitch_roller_diameter + 0.25,
    length,
    microswitch_body_thickness
  ], center=true);
}

module arm_path() {
  linear_extrude(microswitch_body_thickness, center=true)
  polygon(points=[
    [ -microswitch_body_width/2, microswitch_body_height - 0.05 ],
    [ microswitch_roller_x, filament_y ],
    [ microswitch_roller_x, microswitch_body_height - 0.05 ]
  ]);
}

module filament_runout_sensor() {
  difference() {
    translate([
      0,
      body_height/2+0.1,
      -wall_thickness/2 - 0.05,
    ])
    cube([
      microswitch_body_width + 2*wall_thickness,
      body_height+0.1,
      body_thickness,
    ], center=true);

    microswitch_body();
    filament_path();
    roller_path();
    arm_path();
  }
  microswitch_positioning_pins();
}

filament_runout_sensor();
