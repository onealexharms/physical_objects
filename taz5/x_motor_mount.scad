
extrusion_width = 20;
rail_thickness = 8;
rail_width = 12;

left_edge_offset = 10;

module extrusion_and_rail() {
    translate([0,0,extrusion_width/2])
    cube([extrusion_width, 2*extrusion_width, extrusion_width], center=true);
    
    translate([0,0,extrusion_width + rail_thickness/2])
    cube([rail_width, 2*extrusion_width, rail_thickness], center=true);
}

module x_motor_mount() {
    import("x_motor_mount_v2.2.stl",convexity=6);
    
    // Plug some holes
    translate([34, 11.5, 6 + 22/2]) cube([22, 20, 15], center=true);
    translate([34, 11.5, 15/2]) cube([18, 16, 15], center=true);
    
    #extrusion_and_rail();
}

x_motor_mount();

