$fn = 25;
fiddyplus_width = 26.7;
fiddyplus_thickness = 1.62;

bracket_width = 10;
bracket_thickness = 3.5;
standoff_height = 10;

total_width = 2 * bracket_thickness + fiddyplus_width;

module clamp(invert=false) {
    cube([
        bracket_thickness,
        standoff_height + fiddyplus_thickness + 3,
        bracket_width,
    ]);
    translate([invert ? -1.5 : 0, standoff_height - bracket_thickness, 0])
    cube([bracket_thickness+1.5, bracket_thickness, bracket_width]);

    translate([invert ? -0.5 : 0, standoff_height + bracket_thickness, 0])
    cube([bracket_thickness+0.5, bracket_thickness, bracket_width]);
}

difference() {
    union() {
        cube([
            total_width,
            bracket_thickness,
            bracket_width
        ]);

        for (x = [
            0,
            fiddyplus_width + bracket_thickness
        ])
        translate([x, 0, 0])
        clamp(x!=0);
    }

    translate([total_width/2, -0.5, bracket_width/2])
    rotate([-90, 0, 0])
    cylinder(d=3.5,h=10);
}

