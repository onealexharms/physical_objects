
width = 60;

extrusion_size = 20;
extrusion_vertical_distance = 80;
linear_rail_carriage_height = 13;
linear_rail_screw_distance = 20;
linear_rail_screw_hole_diameter = 3.5;
linear_rail_countersink_diameter = 6.5 + 0.5;
linear_rail_countersink_depth = 3.5 + 0.5;

leadscrew_nut_diameter = 10;
leadscrew_nut_flange_diameter = 22;
leadscrew_nut_flange_thickness = 4;
leadscrew_nut_length = 10;
antibacklash_nut_width = 11.2;
leadscrew_distance_from_extrusion_centerline = 25;

thickness = 2 * linear_rail_countersink_depth + 2;

//TODO: Move leadscrew Z to the right offset.
//TODO: Bolt holes for Z carriage.
//TODO: Fix shape of leadscrew positive.

module z_axis_bracket() {
    module plate() {
        translate([0, thickness/2, 0])
        cube([
            width,
            thickness,
            extrusion_vertical_distance + linear_rail_screw_distance + 10
        ],center=true);
    }

    module m3_shcs_counterbored() {
        union() {
            cylinder($fn=35, h=thickness+0.2, d=linear_rail_screw_hole_diameter);
            cylinder($fn=35, h=linear_rail_countersink_depth+0.1, d=linear_rail_countersink_diameter);
        }
    }

    module linear_rail_screw_holes() {
        for (x = [-linear_rail_screw_distance/2, +linear_rail_screw_distance/2])
        for (z = [-extrusion_vertical_distance/2, +extrusion_vertical_distance/2])
        for (zz = [-linear_rail_screw_distance/2, +linear_rail_screw_distance/2])
        translate([x, -0.1, z+zz])
        rotate([-90,0,0])
        m3_shcs_counterbored();
    }
    
    module leadscrew_orientation() {
        translate([-width/2, thickness - ls_offset_from_back, 0])
        rotate([0,90,0])
        children();
    }
    
    module antibacklash_flange() {
        intersection() {
            cylinder($fn=50, d=leadscrew_nut_flange_diameter + 0.5, h=leadscrew_nut_flange_thickness + 0.1);
            translate([0, 0, leadscrew_nut_flange_thickness/2])
            cube([leadscrew_nut_flange_diameter + 1.0, antibacklash_nut_width + 1.0, leadscrew_nut_flange_thickness + 0.1], center=true);
        }
    }

    ls_offset_from_back = leadscrew_distance_from_extrusion_centerline -
        extrusion_size/2 -
        linear_rail_carriage_height;

    module antibacklash_nut_drills() {
        offset = ((leadscrew_nut_flange_diameter/2)^2 - (antibacklash_nut_width/2)^2)^0.5;
        depth = width - 2*leadscrew_nut_flange_thickness - leadscrew_nut_length/2;
        echo("slot drill offset=",offset,", depth=", depth);

        hull()
        for (p = [ -offset, 0, +offset ])
        translate([p, 0, -0.1])
        cylinder(d=11.7, h=depth);
    }

    difference() {
        union() {
            plate();
            leadscrew_orientation() cylinder($fn=50, d=25, h=width);
        }
        linear_rail_screw_holes();

        leadscrew_orientation() {
            translate([0, 0, -0.1]) cylinder($fn=50,d=leadscrew_nut_diameter + 0.5, h=width+0.2);

            translate([0, 0, width - leadscrew_nut_flange_thickness + 0.1])
            cylinder($fn=50, d=leadscrew_nut_flange_diameter + 0.5, h=leadscrew_nut_flange_thickness + 0.1);

            antibacklash_nut_drills();
        }
    }
}

z_axis_bracket();
