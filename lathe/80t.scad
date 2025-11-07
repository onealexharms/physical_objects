use <gears.scad>;

width = 7.92;
bore = 12 + 0.2;
key_width = 3 + 0.2;
key_depth = 1.7 + 0.1;

difference() {
  spur_gear(1, 80, width=width, bore=bore, optimized=true, $fn=100);

  translate([0, bore/4 + key_depth/2, width/2-0.1])
    cube([key_width, bore/2 + key_depth, width+0.2], center=true);
}
