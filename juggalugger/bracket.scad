include <BOSL2/std.scad>;
use <../broom/threads.scad>;

$fn = 50;

module bracket(
    thread_diameter = 17.5,
    thread_tpi = 5,
    thread_height = 1*INCH,
    base_height = 3/8*INCH,
    base_width = 2.5*INCH,
    bolt_distance = 2*INCH,
    bolt_hole_diameter = 6.5,
    material_thickness = 10,
)
{
    module base() {
        translate([0, 0, base_height/2])
        cuboid([base_width, base_width, base_height], rounding=3, edges="Z");
    }

    module threads() {
        broom_threads(inside=false, length=thread_height);
    }
    
    module bolt_holes() {
        for (x = [-bolt_distance/2, +bolt_distance/2])
        for (y = [-bolt_distance/2, +bolt_distance/2])
        translate([x, y, -0.1])
        cylinder(d=bolt_hole_diameter, h=base_height+0.2);
    }

    difference() {
        union() {
            cylinder(d2=1*INCH, d1=2*INCH, h=25);
            base();
        }

        threads();
        bolt_holes();
    }
}

bracket($fn=45);
