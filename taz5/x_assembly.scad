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

m3_clearance_diameter = 3.6;
m3_head_height = 3.8;
m3_head_diameter = 8; // for 7mm washer

thickness = 6;
layer_height = 0.225;

rail_distance = 0; // technically 7?

// Features of original motor mount
top_block_width = 20;
top_block_height = 22;
top_block_thickness = 27;
rail_block_width = 27;
rail_block_height = 32;
rail_block_thickness = 30;

block_distance = 46;
total_height = rail_block_height + top_block_height + (90 - 22 - 22);

heat_set_insert_inside_diameter = 6.5;
heat_set_insert_outside_diameter = 13;
heat_set_insert_length = 7.5;
heat_set_insert_positions = [ // xz
  [ -29.5, 30  ],
  [     0, 6.5 ],
  [ +29.5, 30  ],
];

motor_plate_width = 43;
motor_plate_height = 50;
motor_plate_thickness = 7.5;

motor_screw_distance = 31;
motor_screw_slot_width = 4;
motor_screw_slot_length = 12; // includes 4mm diameter
motor_shaft_hole_width = 26;
motor_shaft_hole_height = 34; // includes 26mm diameter?

end_stop_distance = 21;
end_stop_screw_distance = 9.4;
end_stop_screw_hole_diameter = 3;

extrusion_width = 20;
extrusion_clearance = 0.15;
rail_thickness = 8;
rail_width = 12;

left_edge_offset = 10;

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
    // hole for body of screw.  A one-layer gap is left to force bridging, and this
    // needs to be drilled out.
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        bottom_bearing_hole_center.x + xofs*bearing_block_screw_x_distance/2,
        bottom_bearing_hole_center.y + yofs*bearing_block_screw_y_distance/2,
        m3_head_height + layer_height,
    ])
    cylinder($fn=50, h=thickness + rail_distance + 0.1, d=m3_clearance_diameter);
    
    for (xofs = [-1, 1])
    for (yofs = [-1, 1])
    translate([
        bottom_bearing_hole_center.x + xofs*bearing_block_screw_x_distance/2,
        bottom_bearing_hole_center.y + yofs*bearing_block_screw_y_distance/2,
        -0.02
    ])
    cylinder($fn=50, h=m3_head_height, d=m3_head_diameter + 0.5);
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

module extrusion_and_rail(length=25, clearance=extrusion_clearance) {
    translate([0,0,0])
    cube([extrusion_width + 2*clearance, length, extrusion_width + 2*clearance], center=true);

    translate([0,0,extrusion_width/2 + rail_thickness/2])
    cube([rail_width + 2*clearance, length, rail_thickness + 2*clearance], center=true);
}

module motor_plate() {
    module shaft_hole() {
        hull() {
            for (x = [-1, 1])
            translate([x*(motor_shaft_hole_height - motor_shaft_hole_width)/2, 0, -0.05])
            cylinder(d=motor_shaft_hole_width, h=motor_plate_thickness+0.1);
        }
    }
    
    module screw_slot() {
        hull()
        for (i = [-1,1])
        translate([i*(motor_screw_slot_length-motor_screw_slot_width)/2, 0, 0])
        cylinder(d=motor_screw_slot_width, h= motor_plate_thickness+0.1, $fn=25);
    }
    
    module screw_slots() {
        for (x = [-motor_screw_distance/2, motor_screw_distance/2])
        for (y = [-motor_screw_distance/2, motor_screw_distance/2])
        translate([x,y,-0.05])
        screw_slot();
    }

    difference() {
        rotate([0, -90, 90])
        translate([0, 0, motor_plate_thickness/2])
        cube([50, motor_plate_width, motor_plate_thickness], center=true);

        rotate([0, -90, 90])
        shaft_hole();
        rotate([0, -90, 90])
        screw_slots();
    }
}

module top_block() {
    rotate([0, -90, 90])
    translate([
        block_distance/2 + top_block_height/2,
        motor_plate_width/2 - rail_block_width/2,
        top_block_thickness/2
    ])
    cube([top_block_height, rail_block_width, top_block_thickness], center=true);
}

module rail_block() {
    descender = 12;
    chamfer_amount = 3;
    module chamfer(length) {
        translate([0, -chamfer_amount, -0.05])
        linear_extrude(length+0.1)
        polygon(points=[
            [-0.05, -0.05],
            [chamfer_amount+0.05, chamfer_amount+0.05],
            [-0.05, chamfer_amount+0.05],
            [-0.05, -0.05],
        ]);
    }
    translate([
        -rail_block_height/2,
        -rail_block_width/2,
        rail_block_thickness/2,
    ])
    difference() {
        translate([0, 0, -descender/2])
        cube([rail_block_height, rail_block_width, rail_block_thickness + descender], center=true);

        translate([0, -4/2, -rail_block_thickness/2 - 5 + extrusion_width/2])
        extrusion_and_rail(rail_block_width-4+0.05);

        translate([-rail_block_height/2 -0.05, 0, -10])
        rotate([0, 90, 0])
        cylinder(d=m3_clearance_diameter, h=10, $fn=50);

        translate([0, +rail_block_width/2 - 5 - 12.5, rail_block_thickness/2 - 9])
        cylinder(d=m3_clearance_diameter, h=10, $fn=50);
        
        translate([0, 0, -rail_block_thickness/2 - 13])
        cylinder(d=m3_clearance_diameter, h=10, $fn=50);

        translate([
            -rail_block_height/2,
            +rail_block_width/2,
            rail_block_thickness/2,
        ])
        rotate([90,0,0])
        chamfer(rail_block_width);

        translate([
            +rail_block_height/2,
            -rail_block_width/2,
            rail_block_thickness/2,
        ])
        rotate([90,0,180])
        chamfer(rail_block_width);
    }
};

module heat_inset_holder() {
    back_thickness = 1;
    union() {
        cylinder(d=heat_set_insert_outside_diameter, h=heat_set_insert_length);
        
        translate([0, -heat_set_insert_outside_diameter/2, 0])
        cube([
            heat_set_insert_outside_diameter/2,
            heat_set_insert_outside_diameter,
            heat_set_insert_length+back_thickness
        ]);

        translate([0, 0, heat_set_insert_length])
        cylinder(d=heat_set_insert_outside_diameter, h=back_thickness);
    }
}

module heat_inset_hole() {
    chamfer_amount = 1.5;

    translate([0,0,-0.05])
    cylinder(d=heat_set_insert_inside_diameter, h=heat_set_insert_length + 0.1, $fn=50);
    
    translate([0,0,-0.05])
    cylinder(d1=heat_set_insert_inside_diameter+chamfer_amount, d2=heat_set_insert_inside_diameter, h=chamfer_amount, $fn=50);
}

module end_stop_mounting_holes() {
    depth = 10;
    
    rotate([0, -90, 90])
    translate([30, motor_plate_width/2 - end_stop_distance, rail_block_thickness - depth + 0.05])
    cylinder(d=end_stop_screw_hole_diameter, h=depth, $fn=50);
    
    rotate([0, -90, 90])
    translate([30 + end_stop_screw_distance, motor_plate_width/2 - end_stop_distance, rail_block_thickness - depth + 0.05])
    cylinder(d=end_stop_screw_hole_diameter, h=depth, $fn=50);
}

module x_motor_mount() {
    //import("x_motor_mount_v2.2.stl",convexity=6);
    module solid_bits() {
        motor_plate();
        top_block();

        translate([
            -block_distance/2 + 1.5,
            0,
            -motor_plate_width/2 - 1.5,
        ])
        rotate([0, -90, 90])
        rail_block();

        for (pos = heat_set_insert_positions)
        translate([-motor_plate_width/2, -pos.y, pos.x])
        rotate([90, 0, 90])
        heat_inset_holder();
    }
    
    difference() {
        solid_bits();

        for (pos = heat_set_insert_positions)
        translate([-motor_plate_width/2, -pos.y, pos.x])
        rotate([90, 0, 90])
        heat_inset_hole();

        end_stop_mounting_holes();
    }
}

// filets/chamfers

module x_idler() {
    module at_heat_set_inserts() {
        for (pos = heat_set_insert_positions)
        translate([0, -pos.y + 17.25, pos.x + 35])
        rotate([-90, 0, 0])
        rotate([0, -90, 0])
        children();
    }

    module solid_bits() {
        #rotate([0, 90, 180]) import("x_idler_v2.4.stl", convexity=6);
        at_heat_set_inserts() heat_inset_holder();
        rail_block();

    }
    
    difference() {
        solid_bits();
        at_heat_set_inserts() heat_inset_hole();
    }
}

module x_assembly() {
    translate([-25, 0, 35]) x_motor_mount();
    //translate([100, -(1 + 28.5 + 4.25), -25]) rotate([90,0,180]) x_carriage();
    translate([125, -17.5, 0]) x_idler();

    translate([40, 5-extrusion_width/2, -4.5])
    rotate([0, -90, 90])
    color("grey") 
    #extrusion_and_rail(150, clearance=0);
}

x_assembly();
//x_idler();

// /* rotate([-90,37,0]) */ x_motor_mount();

//extrusion_and_rail();
//difference() {
//    heat_inset_holder();
//    heat_inset_hole();
//}

// - [ ] Make the idler handle the extrusion/rail 
