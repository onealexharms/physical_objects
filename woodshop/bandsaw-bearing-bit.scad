

difference() {
  union() {
    cylinder(d=12.9, h=1.6, $fn=50);
    cylinder(d=8, h=7, $fn=50);
  }
  translate([0,0,-0.1]) cylinder(d=5.25, h=9, $fn=50);
}
