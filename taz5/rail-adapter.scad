$fn = 50;

bearing_block_screw_x_distance = 20;
bearing_block_screw_y_distance = 20;
bearing_block_height = 27;
bearing_block_width = 46;
bearing_block_thickness = 4.25; // well, this is what we'll use
bearing_block_screw_diameter = 3;

carriage_screw_x_distance = 25;
carriage_screw_y_distance = 32;
carriage_screw_diameter = 5;

adapter_width = carriage_screw_x_distance + carriage_screw_diameter + 10;
adapter_height = carriage_screw_y_distance + carriage_screw_diameter + 10;
adapter_thickness = bearing_block_thickness + 7;

module bearing_block() {
    translate([0, 0, bearing_block_thickness/2])
    cube([bearing_block_width, bearing_block_height, bearing_block_thickness], center = true);
}

module rail_adapter() {
    difference() {
        union() {
            translate([0, 0, adapter_thickness/2])
            cube([adapter_width, adapter_height, adapter_thickness], center=true);
        }
        
        bearing_block();
        
        for (x = [-carriage_screw_x_distance/2, +carriage_screw_x_distance/2])
        for (y = [-carriage_screw_y_distance/2, +carriage_screw_y_distance/2])
        translate([x, y, 0])
        cylinder(h=20, d=carriage_screw_diameter);
        
        for (x = [-bearing_block_screw_x_distance/2, +bearing_block_screw_x_distance/2])
        for (y = [-bearing_block_screw_y_distance/2, +bearing_block_screw_y_distance/2])
        translate([x, y, 0])
        cylinder(h=20, d=bearing_block_screw_diameter);
    }
}

rail_adapter();
