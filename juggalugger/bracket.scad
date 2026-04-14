include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;

module bracket(
    thread_diameter = 3/4*INCH,
    thread_tpi = 5,
    thread_height = 1*INCH,
    base_height = 3/8*INCH,
    base_width = 2.5*INCH,
    bolt_distance = 2*INCH,
    bolt_hole_diameter = 6.5,
)
{
    module base() {
        translate([0, 0, base_height/2])
        cube([base_width, base_width, base_height], center=true);
    }

    difference() {
        union() {
            cylinder(d=1*INCH, h=25);
            base();
        }

        translate([0, 0, thread_height/2])
        acme_threaded_rod(
            d=thread_diameter,
            l=thread_height,
            tpi=thread_tpi,
            internal=true,
        );
        
        for (x = [-bolt_distance/2, +bolt_distance/2])
        for (y = [-bolt_distance/2, +bolt_distance/2])
        translate([x, y, -0.1])
        cylinder(d=bolt_hole_diameter, h=base_height+0.2);
    }
}

bracket($fn=45);
