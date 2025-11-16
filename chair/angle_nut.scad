
$fn = 50;
angle = 15.0;
width = 1 * 25.4;
corner_radius = 5;


difference() {
  cube([25.4, 25.4, 25.4], center=true);
  
  translate([1, 0, 0]) cylinder(d=15/32*25.4, h=25.6, center=true);

  //translate([0, 0, -6]) rotate([0, 15, 0]) cube([50, 25.6, 25.4], center=true);
  translate([0, 0, -110]) rotate([0, 15+90, 0]) cylinder(h=250, d=225.4, center=true, $fn=150);
  
  for (y = [-1, 1])
  translate([width/2 - corner_radius, y*(width/2 - corner_radius), 0])
  difference() {
    translate([corner_radius/2, y*corner_radius/2, -0.1])
    cube([corner_radius+0.1, corner_radius+0.1, 25.6], center=true);
    cylinder(r = corner_radius, h=25.6, center=true);
  }

}
