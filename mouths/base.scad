include <polyround.scad>;

$fn = 70;
inch = 25.4;

small_diameter = 3.5*inch;
large_diameter = 8*inch;
center_distance = 4.5*inch;

pipe_height = 3*inch;
pipe_diameter = 2*inch;
pipe_wall_thickness = 1/4*inch;

neck_height = 2.5*inch;
neck_diameter = small_diameter - 0.5*inch;

function noRound(points) = [ for (p = points) [ p.x, p.y ] ];

module base() {
    module footprint() {
        difference() {
            union() {
                  circle(d=small_diameter);
                  translate([0, -center_distance, 0])
                      circle(d=large_diameter);
            }
            //polygon(points=noRound([
            //    [ -small_diameter/2,                 0, small_diameter],
            //    [                 0, +small_diameter/2, small_diameter],
            //    [ +small_diameter/2,                 0, small_diameter],
            //    [
            //      (+small_diameter/2 + large_diameter/2)/2 - 20,
            //      (0 - center_distance)/2 + 10,
            //      10*inch
            //    ],
            //    [  large_diameter/2,                    -center_distance, large_diameter],
            //    [                 0, -center_distance - large_diameter/2, large_diameter],
            //    [ -large_diameter/2,                    -center_distance, large_diameter],
            //    [
            //      (-small_diameter/2 - large_diameter/2)/2 + 20,
            //      (0 - center_distance)/2 + 10,
            //      10*inch
            //    ]
            //], fn=25));
            circle(d=pipe_diameter);
            translate([0, -5.5*inch, 0])
            circle(d=6*inch);
        }
    }

    linear_extrude(h=1*inch) footprint();
}

module pipe() {
        difference() {
            cylinder(d=pipe_diameter, h=pipe_height);
            translate([0, 0, -0.1])
                cylinder(d=pipe_diameter-2*pipe_wall_thickness, h=pipe_height+0.2);
        }
}

color("grey") base();
%pipe();
