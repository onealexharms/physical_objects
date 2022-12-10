difference() {

  union() {
    center();
    top();
    top_bottom();
    }

    choppers();
  }

module top_bottom() {
    cylinder(h=2, r=30);
    }

module top() {
  translate([0,0,15])
    top_bottom();
    }

module center() {
  translate([0,0,2])
    difference() {
      cylinder(h=15, r=15);
      cylinder(h=15, r=13);
    }
  }

module chopper() {
  cube([15,60,21],false);
  }

module choppers() {
  translate([15,-30,-1])
    chopper();
  translate([-30,-30,-1])
    chopper();
  south_hole();
  north_hole();
  corner_holes();
  }

module corner_holes() {
  translate([15,29,-1])
    cylinder(h=21, r=5);
  translate([-15,29,-1])
    cylinder(h=21, r=5);
  translate([15,-29,-1])
    cylinder(h=21, r=5);
  translate([-15,-29,-1])
    cylinder(h=21, r=5);
}

module south_hole() {
    translate([0,-22,-1])
      hole_bit();
    translate([2,-22,-1])
      hole_bit();
    translate([-2,-22,-1])
      hole_bit();
    translate([-4,-22,-1])
      hole_bit();
    translate([4,-22,-1])
      hole_bit();
}

module north_hole() {
  translate([0,22,-1])
    hole_bit();
  translate([2,22,-1])
    hole_bit();
  translate([4,22,-1])
    hole_bit();
  translate([-2,22,-1])
    hole_bit();
  translate([-4,22,-1])
    hole_bit();
}

module hole_bit() {
  cylinder(h=21,r=3);
  }
