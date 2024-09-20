
top_bearing_hole_center = [ 50, 91 ];
top_bearing_x_hole_distance = 91;
top_bearing_y_hole_distance = 32;

bottom_bearing_hole_center = [ 50, 21 ];
bottom_bearing_x_hole_distance = 25;
bottom_bearing_y_hole_distance = 32;

bearing_block_screw_x_distance = 20;
bearing_block_screw_y_distance = 20;
bearing_block_height = 27;
bearing_block_width = 46;
bearing_block_thickness = 4.25; // well, this is what we'll use

m3_head_height = 3;
m3_head_diameter = 5.5;
m3_washer_thickness = 0.25;

rail_distance = 4; // technically 7?

// 12.5

module top_bearing_hole_plugs() {
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        top_bearing_hole_center.x + xofs*top_bearing_x_hole_distance/2,
        top_bearing_hole_center.y + yofs*top_bearing_y_hole_distance/2,
        0
    ])
    cylinder(h=6, d=6);
}

module bottom_bearing_hole_plugs() {
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        bottom_bearing_hole_center.x + xofs*bottom_bearing_x_hole_distance/2,
        bottom_bearing_hole_center.y + yofs*bottom_bearing_y_hole_distance/2,
        0
    ])
    cylinder(h=6, d=6);
}

module bottom_relief_plug() {
    translate(bottom_bearing_hole_center)
    translate([0, 0, 6/2])
    cube([91, 25, 6], center=true);
}

module bearing_block_holder() {
    edge_thickness = 6;
    registration_edge_thickness = rail_distance + bearing_block_thickness;
    
    translate(bottom_bearing_hole_center)
    translate([0, 0, 6])
    difference() {
        translate([-0.01, -0.01, registration_edge_thickness/2 + 0.01])
        cube([bearing_block_width + 2*edge_thickness, bearing_block_height + 2*edge_thickness, registration_edge_thickness], center=true);
    
        translate([-0.01, -0.01, registration_edge_thickness - bearing_block_thickness/2 + 0.01])
        cube([bearing_block_width+0.05, bearing_block_height, bearing_block_thickness+0.02], center=true);
    }
}

module bearing_block_screw_holes() {
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        bottom_bearing_hole_center.x + xofs*bearing_block_screw_x_distance/2,
        bottom_bearing_hole_center.y + yofs*bearing_block_screw_y_distance/2,
        0
    ])
    cylinder($fn=50, h=6 + rail_distance + 0.1, d=3.1);
    
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        bottom_bearing_hole_center.x + xofs*bearing_block_screw_x_distance/2,
        bottom_bearing_hole_center.y + yofs*bearing_block_screw_y_distance/2,
        -0.02
    ])
    cylinder($fn=50, h=m3_head_height + m3_washer_thickness + 0.1, d=m3_head_diameter+0.2);
}

module x_carriage() {
    difference() {
    	union() {
            // Original TAZ5 carriage STL
            import("x_carriage_v2.0.stl", convexity=6);

            top_bearing_hole_plugs();
            bottom_bearing_hole_plugs();
            bottom_relief_plug();

            bearing_block_holder();
        }
        bearing_block_screw_holes();
    }
}

x_carriage();
