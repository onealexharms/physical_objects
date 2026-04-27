include <BOSL2/std.scad>;

module side_bracket(
    base_width = 2.5*INCH,
    top_height = 3/16*INCH,
    panel_height = 10,
    bottom_height = 3/8*INCH,
    bolt_distance = 1.75*INCH,
    bolt_hole_diameter = 6.5,
)
{
    height = top_height + panel_height + bottom_height; 

    difference() {
        translate([0, 0, height/2 - bottom_height])
        cube([base_width, base_width, height], center=true);

        translate([-50, 0, 0])
        #cube([100, 100, panel_height]);

        translate([0, -27.25/2 -2, -bottom_height-0.1])
        cylinder(h=height+0.2,d=27.25,$fn=6);
        
        for (x = [-bolt_distance/2, +bolt_distance/2])
        for (y = [+bolt_distance/2, +5])
        translate([x, y, 0])
        cylinder(d=bolt_hole_diameter, h=height+0.2);
    }
}


side_bracket();
