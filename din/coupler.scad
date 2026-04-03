
width = 24.9;
hole_distance = 25.4;
extra = 12.7;
length = hole_distance + 2*extra;
thickness = 4;
$fn = 25;

difference() {
    cube([length, width, thickness]);
    for (x = [
        (length - hole_distance)/2,
        length - (length - hole_distance)/2
    ])
    translate([x, width/2, -0.1])
    cylinder(d=6.5, h=2*thickness);
}
