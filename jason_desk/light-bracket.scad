$fn = 50;

module vesa_mount(thickness = 5, spacing = 100, bolt_diameter = 6) {
  module at_bolt_holes() {
    for (x = [-spacing/2, +spacing/2])
    for (y = [-spacing/2, +spacing/2])
    translate([x, y, 0])
    children();
  }

  difference() {
    union() {
      at_bolt_holes() cylinder(d=bolt_diameter + 15, h=thickness);

      translate([0,0,thickness/2])
      cube([spacing, spacing, thickness], center=true);
    }
    
    at_bolt_holes() translate([0,0,-0.01]) cylinder(d=bolt_diameter + 0.5, h=thickness+0.02);
  }
}

module light_bracket() {
  wide_width = 90;
  length = 125;
  thickness = 5;
  narrow_width = 10 + 2*5 + 2*thickness; 

  module gusset() {
    translate([wide_width/2-0.75,3.2,0])
    rotate([0,-90,13.5])
    linear_extrude(thickness)
    polygon(points=[
      [0,0],
      [narrow_width, length],
      [0, length]
    ]);
  }

  linear_extrude(thickness)
  polygon(points=[
    [+narrow_width/2, +length],
    [+wide_width/2, 0],
    [-wide_width/2, 0],
    [-narrow_width/2, +length],
  ]);

  translate([0, 125 - thickness/2, narrow_width/2 + thickness])
  difference() {
    cube([narrow_width, thickness, narrow_width], center=true);

    translate([0,-thickness/2 - 0.1,0])
    rotate([-90,0,0])
    cylinder(d=10.5, h=thickness+0.2);
  }
  
  gusset();
  mirror([1,0,0]) gusset();
}

vesa_mount();
translate([0, 100/2, 0])
light_bracket();
