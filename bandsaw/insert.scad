
diameter = 60;
thickness = 3;
chamfer = 1;

cylinder(d=diameter, h=thickness-chamfer, $fn=75);
translate([0, 0, thickness-chamfer])
cylinder(d1=diameter, d2=diameter-2*chamfer, h=chamfer);
