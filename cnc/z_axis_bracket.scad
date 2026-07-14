
width = 60;

extrusion_size = 20;
extrusion_vertical_distance = 75;

linear_rail_carriage_height = 13;
linear_rail_carriage_width = 27;
linear_rail_screw_distance = 20;
linear_rail_screw_hole_diameter = 3.5;
linear_rail_countersink_diameter = 6.5 + 0.5;
linear_rail_countersink_depth = 3.5 + 0.5;

leadscrew_height = 75/2 - 39.47;
echo("leadscrew_height=",leadscrew_height);

leadscrew_nut_diameter = 10.5;
leadscrew_nut_flange_diameter = 22;
leadscrew_nut_flange_thickness = 4;
leadscrew_nut_length = 10;
antibacklash_nut_width = 11.2;
antibacklash_nut_depth = 25;

// 1mm (ruler=1mm) + 0.198" (gauge blocks=4.8mm) + 7.94/2 (half leadscrew=3.97mm) +
// 10mm (half extrusion) + 8mm (rail thickness) = 27.9992
leadscrew_distance_from_extrusion_centerline = 28;

thickness = 13;

carriage_bolt_square_width = 45;
carriage_bolt_square_height = 70;

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
        ls_offset_from_back = leadscrew_distance_from_extrusion_centerline -
            extrusion_size/2 -
            linear_rail_carriage_height;

        translate([-width/2, thickness - ls_offset_from_back, leadscrew_height])
        rotate([0,90,0])
        children();
    }

    module antibacklash_nut_drills() {
        offset = ((leadscrew_nut_flange_diameter/2)^2 - (antibacklash_nut_width/2)^2)^0.5;
        depth = width - 2*leadscrew_nut_flange_thickness - leadscrew_nut_length/2;
        echo("slot drill offset=",offset,", depth=", depth);

        hull()
        for (p = [ -offset, +offset ])
        translate([p, 0, -0.1])
        cylinder($fn=50, d=11.7, h=antibacklash_nut_depth);

        translate([0, 0, -0.1])
        cylinder($fn=50, d=14, h=depth);
    }

    difference() {
        chamfer = 2;
        wall_thickness = 2.5;

        carriage_offset = extrusion_vertical_distance/2 - linear_rail_carriage_width/2 - 0.5;
        ls_offset_from_back = leadscrew_distance_from_extrusion_centerline -
            extrusion_size/2 -
            linear_rail_carriage_height;
        
        union() {
            plate();

            //leadscrew_orientation()
            translate([-width/2, thickness - ls_offset_from_back, 0])
            rotate([0, 90, 0])
            linear_extrude(width)
            polygon(points=[
                [carriage_offset, 0],
                [carriage_offset, +antibacklash_nut_width/2 + wall_thickness - chamfer + 5],
                [carriage_offset-chamfer, +antibacklash_nut_width/2 + wall_thickness + 5],
                [-carriage_offset+chamfer, +antibacklash_nut_width/2 + wall_thickness + 5],
                [-carriage_offset, +antibacklash_nut_width/2 + wall_thickness - chamfer + 5],
                [-carriage_offset, 0],
            ]);
        }
        linear_rail_screw_holes();

        leadscrew_orientation() {
            translate([0, 0, -0.1]) cylinder($fn=50,d=leadscrew_nut_diameter + 0.5, h=width+0.2);

            translate([0, 0, width - leadscrew_nut_flange_thickness + 0.1])
            cylinder($fn=50, d=leadscrew_nut_flange_diameter + 0.5, h=leadscrew_nut_flange_thickness + 0.1);

            antibacklash_nut_drills();
        }
        
        for (x = [-carriage_bolt_square_width/2, +carriage_bolt_square_width/2])
        for (z = [
            leadscrew_height - carriage_bolt_square_height/2, 
            leadscrew_height + carriage_bolt_square_height/2,
        ])
        translate([x, 0, z])
        rotate([-90,0,0])
        translate([0,0,-0.1])
        cylinder($fn=50, d=5.5, h=thickness+0.2);
    }
}

z_axis_bracket();
