inch = 25.4;

thickness        = 11.5;
m4_hole_diameter = 3.8;

hole_distance = 5.5 * inch;
busbar_length = 125.5;
height = 78;

leg_internal_radii = 25;

use <polyround.scad>;

module gridpattern(memberW = 4, sqW = 12, iter = 5, r = 3){
	round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}

module standoff() {
    module frame() {
        linear_extrude(thickness)
        shell2d(-8) {
          polygon(polyRound([
              [                                                0,                  0, 0 ],
              [                                                0,          thickness, 2 ],
              [                               leg_internal_radii,          thickness, leg_internal_radii ],
              [                               leg_internal_radii, height - thickness, leg_internal_radii ],
              [                                                0, height - thickness, 2 ],
              [                                                0,             height, 0 ],
              [                      busbar_length + 2*thickness,             height, 0 ],
              [                      busbar_length + 2*thickness, height - thickness, 2 ],
              [ busbar_length + 2*thickness - leg_internal_radii, height - thickness, leg_internal_radii ],
              [ busbar_length + 2*thickness - leg_internal_radii,          thickness, leg_internal_radii ],
              [                      busbar_length + 2*thickness,          thickness, 2 ],
              [                      busbar_length + 2*thickness,                  0, 0 ],
          ], 10));
          gridpattern(sqW = 25, iter=12);
        }
    }

    difference() {
        frame();
        for (x = [
            thickness + (busbar_length/2 - hole_distance/2),
            busbar_length + thickness - (busbar_length/2 - hole_distance/2),
        ])
           translate([x, -0.1, thickness/2])
           rotate([-90,0,0])
           cylinder(d=m4_hole_diameter, h=height+0.2, $fn=30);
    }
}

standoff();
