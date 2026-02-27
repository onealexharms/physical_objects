width = 18.7;
total_length = 79.5;
thickness = 3;
slit_width = 1/8 * 25.4 + 1.5;
slit_adjust = +0.5;

module shadow_mask() {
    length = total_length - width/2;
    module body() {
        cube([width, length, thickness], center = true);
    
        translate([0, length/2, 0])
        cylinder(d = width, h = thickness, center = true);
        
        translate([0, 0, -thickness/2 -1/2])
        cube([width + 2, length + 2, 1], center = true);
        
        translate([0, length/2, -thickness/2 -1/2])
        cylinder(d = width + 2, h = 1, center = true);
    }
   
    difference() {
        body();
        translate([slit_adjust, width/4, 0])
        cube([slit_width, length, thickness + 5.2], center=true);
    }
}

shadow_mask();
