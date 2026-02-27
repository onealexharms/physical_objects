$fn=96;

clearance = 0.25;

module din_clip(width=10) {
    translate([-0.25,0,0])
        linear_extrude(height=width, center=true, convexity=5)
        polygon([
            [  0.00,  0.00 ],
            [  0.00, 50.00 ],
            [ 16.00, 50.00 ],
            [ 16.50, 49.75 ],
            [ 17.50, 49.00 ],
            [ 17.75, 47.50 ],
            [ 17.75, 35.00 ],
            [ 16.00, 35.00 ],
            [ 14.75, 37.50 ],
            [ 13.75, 37.50 ],
            [ 13.75,  3.75 ],
            [ 13.00,  3.00 ],
            [  4.50,  3.00 ],
            [  4.00,  2.50 ],
            [  4.50,  2.00 ],
            [ 15.00,  2.00 ],
            [ 15.00,  4.50 ],
            [ 19.50,  1.00 ],
            [ 19.50,  0.00 ],
        ]);
}

module pcb_din_clip(
    width=10,
    hole_distance=96,
    hole_diameter=4,
    mount_thickness=5,
    nut_flats_width=7.0,
    nut_corners_width=8.08,
    nut_thickness=3.2,
) {
    mount_length       = hole_distance + 2*nut_corners_width;
    nut_hole_width     = nut_flats_width + clearance;
    nut_hole_thickness = nut_thickness + clearance;

    module nut_slot() {
        translate([mount_thickness - nut_hole_thickness + 0.1, -nut_hole_width/2, -nut_corners_width/2])
            cube([nut_hole_thickness, nut_hole_width, 2*nut_hole_width]);
    }

    module hole() {
        rotate([0,90,0])
            translate([0,0,-0.1])
            cylinder(d=hole_diameter,h=mount_thickness+0.2);
        nut_slot();
    }

    difference() {
        translate([-mount_thickness,-mount_length/2+25,-width/2])
            cube([mount_thickness,mount_length,width]);
        for (offset = [-0.5, +0.5])
            translate([-mount_thickness, 25 + offset * hole_distance, 0])
                hole();
    }

    din_clip(width=width);
}

pcb_din_clip(
    width=10,
    hole_distance= 47,
    hole_diameter=4,
    mount_thickness=8,
    
    /* M4 */
    nut_flats_width=7.0,
    nut_corners_width=8.08,
    nut_thickness=3.2,
);
