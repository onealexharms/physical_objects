use <../utility/round-bottom-box.scad>

module shell() {
  difference() {
    round_bottom_box (13,18,12,2);
    translate([2, 2, 2])
      round_bottom_box (9,14,10,2); 
  }
}

module cord() {
  translate([0,6,5])
    cube([4,4,6]);
}

module lid_box() {
  difference() {
    round_bottom_box(15, 20, 10, 2);
    translate([2, 2, 2])
      round_bottom_box(11, 16, 8, 2);
  }
}

module hole_for_switch() {
  translate([3,2,0]) {
    cube([9, 14, 18]);
  }
}

module lid() {
  difference() {
    lid_box();
    hole_for_switch();
  }
}

module bottom() {
  difference() {
    shell();
    cord();
  }
}

bottom();
