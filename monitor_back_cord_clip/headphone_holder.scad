difference() {

  union() {
    center();
    top();
    top_bottom();
    }
    choppers();
    holes();
  }

module top_bottom() {
  cylinder(h=2, r=30);
  }

translate([5,-16,16]) {
  rotate(90) {
    linear_extrude(2) {
      text("JAKUB");  
        }
    }
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

module hole() {
  translate([0,0,-1])
    hole_bit();
  translate([-2,0,-1])
    hole_bit();
  translate([2,0,-1])
    hole_bit();
  }

module holes() {
  translate([0,22,0])
    hole();
  translate([0,-22,15])
    hole();
  }

module hole_bit() {
  cylinder(h=5,r=5);
  }
