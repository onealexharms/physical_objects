
width = 0.5 * 25.4;
depth = (0.93 - 0.06) * 25.4;
height = 3;

latch_depth = 0.395 * 25.4;
latch_width = 5;

descender = 8;

difference() {
    translate([0,0, -descender])
    cube([4.3, width, descender+height]);
    
    translate([2+2.3, -0.01, -2.3])
    rotate([-90,0,0])
    cylinder(r=2.3,h=width+0.1, $fn=50);
    
    translate([2, -0.01, -2.3-8])
    cube([3, width+0.1, 8]);
}


difference() {
  cube([depth, width, height]);
  
  translate([depth-latch_depth+0.01, (width-latch_width)/2, -0.01])
    cube([latch_depth + 0.1, latch_width, height + 0.2]);
    
  translate([(depth-latch_depth)/2, width/2, -5])
    cylinder(d=3,h=10,$fn=50);
    
  translate([(depth-latch_depth)/2+6, width/2, -5])
  cylinder(d=latch_width,h=10,$fn=50);
}
