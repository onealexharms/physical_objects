
INCH = 25.4;

module motor_bracket(
    motor_bolt_hole_distance = 4*INCH,
    motor_bolt_hole_diameter = 0.2*INCH,
    shaft_hole_diameter = 9/16*INCH,
    arm_width = 1*INCH,
    material_thickness = 1/2*INCH,
    arm_thickness = 1/4*INCH,
    bell_height = 1.4*INCH,
    center_diameter = 2*INCH,
    bushing_diameter = 1.494*INCH,
    bottom_cut_away_diameter = 3*INCH,
) {
    material_cut_away = material_thickness - arm_thickness;
    spacer_height = bell_height - material_cut_away;

    bushing_bolt_radius = (bushing_diameter/2 + shaft_hole_diameter/2)/2;
    
    module shaft_hole() {
        cylinder(d=shaft_hole_diameter, h=10*INCH);
    }
    module motor_bolt_hole() {
        cylinder(d=motor_bolt_hole_diameter, h=10*INCH);
    }
    module motor_bolt_hole_positions() {
        for (x = [-motor_bolt_hole_distance/2, +motor_bolt_hole_distance/2])
        for (y = [-motor_bolt_hole_distance/2, +motor_bolt_hole_distance/2])
        translate([x, y, 0])
        children();
    }
    module motor_bolt_holes() {
        motor_bolt_hole_positions() motor_bolt_hole();
    }
    module bushing_bolt_holes() {
        r = bushing_bolt_radius;
        for (p = [
            [ -r,  0, 0 ],
            [ +r,  0, 0 ],
            [  0, +r, 0 ],
            [  0, -r, 0 ]
        ])
        translate(p)
        motor_bolt_hole();
    }
    module holes() {
        motor_bolt_holes();
        bushing_bolt_holes();
        shaft_hole();
    }

    module bracket_projection() {
        for (x = [-motor_bolt_hole_distance/2, +motor_bolt_hole_distance/2])
        for (y = [-motor_bolt_hole_distance/2, +motor_bolt_hole_distance/2])
        hull() {
           circle(d=arm_width);
           translate([x, y, 0]) circle(d=arm_width);
        }
        circle(d=center_diameter);
    }

    module bottom_cut_away() {
        translate([0, 0, bell_height-material_cut_away-0.05])
        cylinder(
            d2=bottom_cut_away_diameter,
            d1=bottom_cut_away_diameter+2*material_cut_away,
            h=material_cut_away+0.1
        );
    }
    
    module top_cut_away() {
        difference() {
            translate([0, 0, bell_height+material_cut_away/2])
            cube([10*INCH, 10*INCH, material_cut_away+0.1], center=true);
       
            translate([0, 0, bell_height-0.05])
            cylinder(
                d2=bottom_cut_away_diameter+2*material_cut_away,
                d1=bottom_cut_away_diameter+4*material_cut_away,
                h=material_cut_away+0.1
            );
        }
    }

    difference() {
        union() {
            translate([0, 0, spacer_height])
                linear_extrude(material_thickness)
                bracket_projection();

            color("beige")
                motor_bolt_hole_positions()
                cylinder(d=arm_width, h=spacer_height);
        }

        holes();
        bottom_cut_away();
        top_cut_away();
    }
}

motor_bracket($fn=25);
