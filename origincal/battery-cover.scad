
width = 20;
thickness = 3;
left_thickness = 1.79;
left_shelf_width = 3;
length = 15.75 + 6.25; //22.4; + 6.25
nub_top = 1.25;
nub_thickness = 1.0; 
nub_width = 2;
left_nub_inset = 1.5;
right_nub_inset = 2.8;
weird_inset = 4;
weird_inset2 = 2.5;

stub_offset = 5.75;
stub_width = 3;
stub_thickness = 1;
stub_length = 1;

module battery_cover() {
  module roundish_profile() {
    translate([0,0,-0.005])
    linear_extrude(thickness+0.01)
    polygon(points=[
      [0.01,       -1],
      [0.01,       6.25],
      
      [-2,         6.25-2.87],
      
      [-width/2+3.5, 0.5],
      [-width/2, 0],
      [-width/2-3.5, 0.5],
      
      [-width+2, 6.25-2.87],
      
      [-width-0.01,   6.25],
      [-width-0.01,   -1],
      [0.01,       -1],
    ]);
  }
  
  difference() {
    translate([-width, 0, 0])
      cube([width, length, thickness]);

    translate([0,0,-0.01])
    linear_extrude(thickness-left_thickness+0.01)
    polygon(points=[ 
      [0.01,              -0.01],
      [-left_shelf_width, -0.01],
      [-left_shelf_width, length - weird_inset2],
      [-1,                length - weird_inset],
      [0.01,              length - weird_inset],
      [0.01,              -0.01],
    ]);

    translate([-nub_width, -0.05, thickness-nub_top-nub_thickness])
      cube([nub_width+0.1, length-left_nub_inset, nub_thickness]);
    translate([-width-0.1, -0.05, thickness-nub_top-nub_thickness])
      cube([nub_width+0.1, length-right_nub_inset, nub_thickness]);
    translate([-width-0.1, -0.05, -0.01])
      cube([nub_width+0.1, length-right_nub_inset-nub_width, nub_thickness]);

    translate([-10, length/2, thickness])
    resize([width-2,length-2,1.75]) sphere(20);
    
    roundish_profile();
  }
  
  translate([-stub_width-stub_offset, -stub_length, 0])
  cube([stub_width, stub_length + 5, stub_thickness]);
}

battery_cover();
