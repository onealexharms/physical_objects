// Features of original model
top_block_width = 20;
top_block_height = 22;
top_block_thickness = 30;
bottom_block_width = 27;
bottom_block_height = 32;
bottom_block_thickness = 30;

block_distance = 46;
total_height = bottom_block_height + top_block_height + (90 - 22 - 22);

heat_set_insert_inside_diameter = 7.8;
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

m3_clearance_diameter = 3.6;

extrusion_width = 20;
rail_thickness = 8;
rail_width = 12;

left_edge_offset = 10;

module extrusion_and_rail(length=25) {
    translate([0,0,extrusion_width/2])
    cube([extrusion_width, length, extrusion_width], center=true);
    
    translate([0,0,extrusion_width + rail_thickness/2])
    cube([rail_width, length, rail_thickness], center=true);
}

module rail_holder() {
    padding = 4;
    xsize = 2*padding + extrusion_width;
    zsize = xsize + rail_thickness;
    ysize = 25;

    difference() {
    	translate([0, 0, zsize/2 - padding])
        cube([xsize, ysize, zsize], center=true);

        #extrusion_and_rail();
    }
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
        translate([0, 0, motor_plate_thickness/2])
        cube([50, motor_plate_width, motor_plate_thickness], center=true);

        shaft_hole();
        screw_slots();
    }
}

module top_block() {
    translate([
        block_distance/2 + top_block_height/2,
        motor_plate_width/2 - bottom_block_width/2,
        top_block_thickness/2
    ])
    cube([top_block_height, bottom_block_width, top_block_thickness], center=true);
}

module bottom_block() {
    descender = 14;
    translate([
        -block_distance/2 - bottom_block_height/2,
        motor_plate_width/2 - bottom_block_width/2,
        bottom_block_thickness/2
    ])
    difference() {
        translate([0, 0, -descender/2])
        cube([bottom_block_height, bottom_block_width, bottom_block_thickness + descender], center=true);
        
        translate([0, -(bottom_block_width/4)/2, -bottom_block_thickness/2 - 5])
        extrusion_and_rail(bottom_block_width-4);
        
        translate([-bottom_block_height/2 -0.05, 0, -10])
        rotate([0, 90, 0])
        cylinder(d=m3_clearance_diameter, h=10, $fn=50);
        
        translate([0, 0, -20 + 0.05])
        rotate([0, 180, 0])
        cylinder(d=m3_clearance_diameter, h=10, $fn=50);
    }
};

module heat_inset_holder() {
    translate([0, motor_plate_width/2, 0])
    rotate([90, 0, 0])
    union() {
        cylinder(d=heat_set_insert_outside_diameter, h=heat_set_insert_length);

        translate([0, 0, heat_set_insert_length])
        cylinder(d=heat_set_insert_outside_diameter, h=1);
    }
}

module heat_inset_hole() {
    translate([0, motor_plate_width/2, 0])
    rotate([90, 0, 0])
    translate([0,0,-0.05])
    cylinder(d=heat_set_insert_inside_diameter, h=heat_set_insert_length + 0.1, $fn=50);
}

module end_stop_mounting_holes() {
    depth = 10;
    
    translate([30, motor_plate_width/2 - end_stop_distance, bottom_block_thickness - depth + 0.05])
    cylinder(d=end_stop_screw_hole_diameter, h=depth, $fn=50);
    
    translate([30 + end_stop_screw_distance, motor_plate_width/2 - end_stop_distance, bottom_block_thickness - depth + 0.05])
    cylinder(d=end_stop_screw_hole_diameter, h=depth, $fn=50);
}

module x_motor_mount() {
    module solid_bits() {
        motor_plate();
        top_block();
        bottom_block();

        for (pos = heat_set_insert_positions)
        translate([pos.x, 0, pos.y])
        heat_inset_holder();
    }
    
    difference() {
        solid_bits();

        for (pos = heat_set_insert_positions)
        translate([pos.x, 0, pos.y])
        heat_inset_hole();
        
        end_stop_mounting_holes();
    }
}

//import("x_motor_mount_v2.2.stl",convexity=6);
x_motor_mount();

// filets/chamfers
// screw holes for T nuts

