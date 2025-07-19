
diameter       = 2.220 * 25.4;
tooth_depth    = 0.164 * 25.4;
teeth          = 22;
shaft_diameter = 1.139 * 25.4;

module ratchet_gear(shrink=0) {
  difference() {
    polygon(points=[
      for (i = [0:teeth-1])
      for (sub = [0, tooth_depth])
      [sin(360/teeth*i) * (diameter/2 - sub - shrink), cos(360/teeth*i) * (diameter/2 - sub - shrink)]
    ]);
    circle(d=shaft_diameter+0.5);
  }
}

/*
color("green") difference() {
  ratchet_gear();
  rotate([0,0,1.5]) ratchet_gear(shrink=0.040*25.4);
}
*/
