include<data/bisley-5-drawer-cabinet.data>;
use <../utility/round-bottom-box.scad>;

wall = 1;
scrapers = 40;
height = 35;
radius = 2;
cup_length = 100 + drawer_lip_thickness;
rulers = cup_length - drawer_lip_thickness - scrapers - 2*wall;

module scraper_space() {
  translate([wall, wall, wall]) {
  round_bottom_box(drawer_width - 2*wall, scrapers, height, radius);
  }
}

module ruler_space() {
  translate([wall, scrapers + 2*wall, wall]) {
  round_bottom_box(drawer_width - 2*wall, rulers, height, radius);
  }
}

difference() {
  round_bottom_box(drawer_width, cup_length, height, radius);
  scraper_space();
  ruler_space();
}
