$fn = 25;

breadboard_width = 54.33;
breadboard_height = 82.17;

hp = 5.08;
panel_height = 128.5;
thickness = 2.5;
cutout_depth = 7;
distance_from_bottom = 10;

screw_hole_diameter = 3.4;
screw_hole_distance = 1.3 + screw_hole_diameter/2;
screw_distance_from_side = 4.5;

module breadboard_pos() {
    translate([0, -panel_height/2 + breadboard_height/2 + distance_from_bottom, 0])
        children();
}

module breadboard(expansion) {
    breadboard_pos()
    cube([breadboard_width+expansion, breadboard_height+expansion, cutout_depth+expansion], center=true);
}

module breadboard_panel(
    wall_thickness=3,
) {
    panel_width = ceil((breadboard_width + 2*wall_thickness)/hp)*hp;

    c = 5; // bridging for corners

    difference() {
        union() {
            cube([panel_width, panel_height, thickness], center=true);
            breadboard(expansion=wall_thickness);
        }

        breadboard(expansion=0.5);

        // bottom cutout to make it printable on the face
        breadboard_pos()
        translate([0,0,-12.5])
        linear_extrude(25)
        polygon(points=[
            [ -breadboard_width/2  , +breadboard_height/2-c ],
            [ -breadboard_width/2+c, +breadboard_height/2   ],
            [ +breadboard_width/2-c, +breadboard_height/2   ],
            [ +breadboard_width/2  , +breadboard_height/2-c ],
            [ +breadboard_width/2  , -breadboard_height/2+c ],
            [ +breadboard_width/2-c, -breadboard_height/2   ],
            [ -breadboard_width/2+c, -breadboard_height/2   ],
            [ -breadboard_width/2  , -breadboard_height/2+c ],
        ]);

        translate([0, 0, 5.0 + thickness/2])
        cube([panel_width + 1.0, panel_height + 1.0, 10.0], center=true);

        // Screw slots
        for (x = [
            panel_width/2  - screw_distance_from_side - screw_hole_diameter/2,
            -panel_width/2 + screw_distance_from_side + screw_hole_diameter/2,
        ])
        for (y = [
            panel_height/2 - screw_hole_distance,
            -panel_height/2 + screw_hole_distance,
        ])
        hull()
        for (xx = [
            -screw_hole_diameter/3,
            +screw_hole_diameter/3
        ])
        translate([x+xx, y, 0])
        cylinder(d=screw_hole_diameter, h=10, center=true);
    }
}

breadboard_panel();
