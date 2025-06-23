
diameter       = 2.220 * 25.4;
tooth_depth    = 0.164 * 25.4;
teeth          = 22;
shaft_diameter = 1.139 * 25.4;

module ratchet_gear() {
  difference() {
    polygon(points=[
      for (i = [0:teeth-1])
      for (sub = [0, tooth_depth])
      [sin(360/teeth*i) * (diameter/2 - sub), cos(360/teeth*i) * (diameter/2 - sub)]
    ]);
    circle(d=shaft_diameter+0.5);
  }
}

ratchet_gear();
