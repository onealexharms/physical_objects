include <polyround.scad>;

$fn = 70;
inch = 25.4;

small_diameter = 3*inch;
large_diameter = 8*inch;
center_distance = 5*inch;

linear_extrude(h=1*inch) {
    polygon(points=polyRound([
        [ -small_diameter/2,                 0, 3.5*inch],
        [                 0, +small_diameter/2, 3.5*inch],
        [ +small_diameter/2,                 0, 3.5*inch],
        [
          (+small_diameter/2 + large_diameter/2)/2 - 20,
          (0 - center_distance)/2 + 10,
          10*inch
        ],
        [  large_diameter/2,                    -center_distance, 8*inch],
        [                 0, -center_distance - large_diameter/2, 8*inch],
        [ -large_diameter/2,                    -center_distance, 8*inch],
        [
          (-small_diameter/2 - large_diameter/2)/2 + 20,
          (0 - center_distance)/2 + 10,
          10*inch
        ]
    ], fn=25));

//    hull() {
//    circle(d=small_diameter);
//    translate([0, -5*inch, 0])
//        circle(d=large_diameter);
//    }
}
//cylinder(d=small_diameter, h=2*inch);
